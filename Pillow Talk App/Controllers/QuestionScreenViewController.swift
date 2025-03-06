//
//  QuestionScreenViewController.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 07.12.2024.
//

import UIKit
import StoreKit
import FirebaseAnalytics

enum CardType {
    case question
    case action
}

class QuestionScreenViewController: UIViewController {
    var questionScreenView: QuestionScreenView!
    private let firebaseService = FirebaseService()
    private var tapCount = 0
    private var selectedElement: ScrollElement?
    private var preloadedQuestion: String?
    private var currentCategory: String = "01" // По умолчанию выбрана категория 01 (Легке знайомство)
    private var isDatesMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F7EEE4")
        setupSwipeGesture()
        checkAndRequestReview()
        setupTapCategory()
        setupTapDatingCup()
        setupTapSettings()
        setupScrollElementsTapActions()
        questionScreenView.bgView.isHidden = true
        
        // Дефолтный цвет иконок при загрузке экрана
        
        questionScreenView.categoryIcon.image = .categoryIconRed
        
        // Устанавливаем дефолтный текст и случайного персонажа для первой карточки
        questionScreenView.questionLabel.text = "Свайпни картку вправо, щоб тут почали зʼявлятися питання. Задавайте їх одне одному з вашим партнером!"
        questionScreenView.labelQuestionOrAction.text = "Питання"
        questionScreenView.labelQuestionOrAction.textColor = UIColor(hex: "#F99F4F")
        questionScreenView.updateCharacterImage() // Добавляем случайного персонажа
        
        // Симулируем нажатие на "Легке знайомство" (индекс 0)
        updateSelectedElement(at: 0)
        
        // Предзагружаем вопрос для категории "01" в фоновом режиме
        firebaseService.getRandomQuestion(for: currentCategory) { [weak self] result in
            if case .success(let question) = result {
                self?.preloadedQuestion = question
            }
        }
    }


    override func loadView() {
        questionScreenView = QuestionScreenView(frame: UIScreen.main.bounds)
        self.view = questionScreenView
    }

    
    // MARK: - Настройка нажатий Bottom Bar
    
    // Категорії питань
    private func setupTapCategory() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapCategory))
        questionScreenView.tapViewOne.addGestureRecognizer(tapGesture)
        questionScreenView.tapViewOne.isUserInteractionEnabled = true
    }
    
    @objc func actionTapCategory() {
        questionScreenView.categoryIcon.image = .categoryIconRed
        questionScreenView.datingCup.image = .cupBlue
        questionScreenView.settingsIcon.image = .settingsBlue

        questionScreenView.questionCardView.isHidden = false
        questionScreenView.bgView.isHidden = true

        // Выключаем режим свиданий и возвращаемся к вопросам
        isDatesMode = false
        currentCategory = "01" // Возвращаемся к категории по умолчанию "Легкое знакомство"
        updateSelectedElement(at: 0) // Выделяем "Легкое знакомство" по умолчанию
        loadContentForCurrentCategory() // Загружаем вопрос для текущей категории

        // Плавно показываем ScrollView
        questionScreenView.scrollView.isHidden = false
        questionScreenView.scrollView.alpha = 0

        UIView.animate(withDuration: 0.3) {
            self.questionScreenView.scrollView.alpha = 1
        }
    }


    // Банка побачень
    private func setupTapDatingCup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapDating))
        questionScreenView.tapViewTwo.addGestureRecognizer(tapGesture)
        questionScreenView.tapViewTwo.isUserInteractionEnabled = true
    }
    
    @objc func actionTapDating() {
        questionScreenView.categoryIcon.image = .categoryIconBlue
        questionScreenView.datingCup.image = .cupRed
        questionScreenView.settingsIcon.image = .settingsBlue
        
        questionScreenView.questionCardView.isHidden = false
        questionScreenView.bgView.isHidden = true
        
        // Включаем режим свиданий
        isDatesMode = true
        loadContentForCurrentCategory() // Загружаем случайную идею для свидания
        
        // Плавно скрываем ScrollView
        UIView.animate(withDuration: 0.3) {
            self.questionScreenView.scrollView.alpha = 0
        } completion: { _ in
            self.questionScreenView.scrollView.isHidden = true
        }
    }
    
    // Профіль
    private func setupTapSettings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapSettings))
        questionScreenView.tapViewThree.addGestureRecognizer(tapGesture)
        questionScreenView.tapViewThree.isUserInteractionEnabled = true
    }
    
    @objc func actionTapSettings() {
        questionScreenView.categoryIcon.image = .categoryIconBlue
        questionScreenView.datingCup.image = .cupBlue
        questionScreenView.settingsIcon.image = .settingsRed
        
        questionScreenView.questionCardView.isHidden = true
        questionScreenView.bgView.isHidden = false
        
        // Плавно скрываем ScrollView
        UIView.animate(withDuration: 0.3) {
            self.questionScreenView.scrollView.alpha = 0
        } completion: { _ in
            self.questionScreenView.scrollView.isHidden = true
        }
    }
    
    // MARK: - Настройка нажатий Scroll View
    private func setupScrollElementsTapActions() {
        guard questionScreenView.stackView.arrangedSubviews.count >= 3 else { return }
        
        if let element1 = questionScreenView.stackView.arrangedSubviews[0] as? ScrollElement {
            element1.addTapGesture(target: self, action: #selector(scrollElementOneTapped))
        }

        if let element2 = questionScreenView.stackView.arrangedSubviews[1] as? ScrollElement {
            element2.addTapGesture(target: self, action: #selector(scrollElementTwoTapped))
        }

        if let element3 = questionScreenView.stackView.arrangedSubviews[2] as? ScrollElement {
            element3.addTapGesture(target: self, action: #selector(scrollElementThreeTapped))
        }
    }
    
    @objc func scrollElementOneTapped() {
        currentCategory = "01" // Легке знайомство
        updateSelectedElement(at: 0)
        loadContentForCurrentCategory()
    }

    @objc func scrollElementTwoTapped() {
        currentCategory = "02" // Глибокий звʼязок
        updateSelectedElement(at: 1)
        loadContentForCurrentCategory()
    }

    @objc func scrollElementThreeTapped() {
        currentCategory = "03" // Разом крізь труднощі
        updateSelectedElement(at: 2)
        loadContentForCurrentCategory()
    }
    

    private func updateSelectedElement(at index: Int) {
        let elements = questionScreenView.stackView.arrangedSubviews.compactMap { $0 as? ScrollElement }
        guard elements.indices.contains(index) else { return }

        for (currentIndex, element) in elements.enumerated() {
            let isSelected = currentIndex == index
            
            element.updateState(
                isSelected: isSelected,
                selectedIcon: selectedIcon(for: currentIndex),
                defaultIcon: defaultIcon(for: currentIndex),
                selectedColor: UIColor(hex: "#DB5A3D"),
                defaultColor: .black
            )
        }

        selectedElement = elements[index]
    }

    private func selectedIcon(for index: Int) -> UIImage {
        switch index {
        case 0: return UIImage(named: "shapeOneIconRed")!
        case 1: return UIImage(named: "shapeSecondIconRed")!
        case 2: return UIImage(named: "shapeThirdRed")!
        default: return UIImage()
        }
    }

    private func defaultIcon(for index: Int) -> UIImage {
        switch index {
        case 0: return UIImage(named: "shapeOneIconBlack")!
        case 1: return UIImage(named: "shapeSecondBlack")!
        case 2: return UIImage(named: "shapeThirdBlack")!
        default: return UIImage()
        }
    }
    
     // MARK: - Загрузка контента для текущей категории
    private func loadContentForCurrentCategory() {
        tapCount = 0 // Сбрасываем счетчик, чтобы начинать с вопросов или идей
        if isDatesMode {
            loadRandomDate()
        } else {
            loadRandomQuestionForCurrentCategory()
        }
    }
    
    
    private func loadRandomDate() {
        firebaseService.getRandomDate { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dateIdea):
                    self?.updateCardContent(with: dateIdea, type: .question) // Переиспользуем карточку вопросов для простоты
                case .failure(let error):
                    print("Ошибка загрузки идеи для свидания: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadRandomQuestionForCurrentCategory() {
        firebaseService.getRandomQuestion(for: currentCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let question):
                    self?.updateCardContent(with: question, type: .question)
                    self?.preloadedQuestion = question
                case .failure(let error):
                    print("Ошибка загрузки вопроса для категории \(self?.currentCategory ?? ""): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadRandomActionForCurrentCategory() {
        firebaseService.getRandomAction(for: currentCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let action):
                    self?.updateCardContent(with: action, type: .action)
                case .failure(let error):
                    print("Ошибка загрузки действия для категории \(self?.currentCategory ?? ""): \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Настройка жестов
    private func setupSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        questionScreenView.questionCardView.addGestureRecognizer(panGesture)
        questionScreenView.questionCardView.isUserInteractionEnabled = true
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let cardView = questionScreenView.questionCardView
        let translation = gesture.translation(in: view)
        let xFromCenter = translation.x
        let rotationAngle = xFromCenter / view.frame.width * 0.4

        switch gesture.state {
        case .changed:
            cardView.transform = CGAffineTransform(translationX: xFromCenter, y: 0)
                .rotated(by: rotationAngle)
        
        case .ended:
            if xFromCenter > 150 {
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center.x += 500
                    cardView.alpha = 0
                }) { _ in
                    self.loadNextCard()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    cardView.transform = .identity
                }
            }
        default:
            break
        }
    }

    private func loadNextCard() {
        let cardView = questionScreenView.questionCardView
        
        // 1. Полностью скрываем карточку и очищаем старый контент
        cardView.alpha = 0
        questionScreenView.questionLabel.text = "" // Очистка текста
        questionScreenView.characterForCard.image = nil // Очистка изображения
        
        // 2. Возвращаем карточку в центр без анимации
        cardView.center = self.view.center
        cardView.transform = .identity
        
        // 3. Загружаем новый контент для текущего режима
        tapCount += 1
        if isDatesMode {
            loadRandomDate()
        } else {
            if tapCount > 1 && (tapCount % 8) == 0 {
                if let preloaded = self.preloadedQuestion { // Используем предзагруженный вопрос, если он есть
                    updateCardContent(with: preloaded, type: .question)
                    self.preloadedQuestion = nil // Сбрасываем после использования
                    loadRandomActionForCurrentCategory() // Загружаем действие для следующего раза
                } else {
                    loadRandomActionForCurrentCategory()
                }
            } else {
                if let preloaded = self.preloadedQuestion { // Используем предзагруженный вопрос, если он есть
                    updateCardContent(with: preloaded, type: .question)
                    self.preloadedQuestion = nil // Сбрасываем после использования
                    loadRandomQuestionForCurrentCategory() // Загружаем новый вопрос для следующего раза
                } else {
                    loadRandomQuestionForCurrentCategory()
                }
            }
        }
        
        // 4. Показываем карточку только после обновления контента
        UIView.animate(withDuration: 0.3) {
            cardView.alpha = 1
        }
    }

    private func updateCardContent(with content: String, type: CardType) {
        questionScreenView.questionLabel.text = content
        if isDatesMode {
            questionScreenView.labelQuestionOrAction.text = "Ідеї"
            questionScreenView.labelQuestionOrAction.textColor = UIColor(hex: "#DB5A3D") // Можно настроить цвет по необходимости
        } else {
            updateQuestionOrActionLabel(for: type)
        }
        questionScreenView.updateCharacterImage() // Восстанавливаем случайного персонажа при каждом обновлении
    }

    private func updateQuestionOrActionLabel(for type: CardType) {
        switch type {
        case .question:
            questionScreenView.labelQuestionOrAction.text = "Питання"
            questionScreenView.labelQuestionOrAction.textColor = UIColor(hex: "#F99F4F")
        case .action:
            questionScreenView.labelQuestionOrAction.text = "Дія"
            questionScreenView.labelQuestionOrAction.textColor = UIColor(hex: "#80B6BC")
        }
    }
}

// MARK: - Оценка для App Store
func checkAndRequestReview() {
    let launchCountKey = "launchCount"
    let popupShowCountKey = "popupShowCount"
    let requestThreshold = 2

    let launchCount = UserDefaults.standard.integer(forKey: launchCountKey) + 1
    UserDefaults.standard.set(launchCount, forKey: launchCountKey)

    print("Количество запусков: \(launchCount)")

    if launchCount == requestThreshold {
        let popupShowCount = UserDefaults.standard.integer(forKey: popupShowCountKey) + 1
        UserDefaults.standard.set(popupShowCount, forKey: popupShowCountKey)

        logPopupReviewShown(showCount: popupShowCount)
        Task { await requestAppReview() }
    }
}

func logPopupReviewShown(showCount: Int) {
    Analytics.logEvent("popup_review_shown", parameters: ["count": showCount])
}

@MainActor
func requestAppReview() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        let clickCountKey = "popupClickCount"
        let clickCount = UserDefaults.standard.integer(forKey: clickCountKey) + 1
        UserDefaults.standard.set(clickCount, forKey: clickCountKey)

        logPopupReviewClicked(clickCount: clickCount)
        AppStore.requestReview(in: windowScene)
    }
}

func logPopupReviewClicked(clickCount: Int) {
    Analytics.logEvent("popup_review_clicked", parameters: ["count": clickCount])
}
