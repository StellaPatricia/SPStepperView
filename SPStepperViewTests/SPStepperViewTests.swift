//
//  SPStepperViewTests.swift
//  SPStepperViewTests
//
//  Created by Stella Patricia on 15/08/24.
//

import XCTest
@testable import SPStepperView

final class SPStepperViewTests: XCTestCase {

    private let completed = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
    private let incomplete = UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2)).image { _ in }

    // Layout only re-runs reliably for views hosted in a window.
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    private func makeStepper(_ count: Int) -> StepperView {
        let stepper = StepperView(
            steps: (1...max(count, 1)).prefix(count).map { "Step \($0)" },
            completedImage: completed,
            incompleteImage: incomplete
        )
        stepper.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        window.addSubview(stepper)
        stepper.layoutIfNeeded()
        return stepper
    }

    private func items(_ stepper: StepperView) -> [StepItemView] {
        stepper.subviews.compactMap { $0 as? UIStackView }.first?
            .arrangedSubviews.compactMap { $0 as? StepItemView } ?? []
    }

    func testInitialStateMarksOnlyFirstStepCompleted() {
        let stepper = makeStepper(4)
        XCTAssertEqual(stepper.currentStepIndex, 0)
        XCTAssertEqual(items(stepper).map { $0.indicatorView.image }, [completed, incomplete, incomplete, incomplete])
    }

    func testPercentageMapsToStepIndex() {
        let stepper = makeStepper(4)
        stepper.setCurrentStepPercentage(0.4, animated: false)
        XCTAssertEqual(stepper.currentStepIndex, 1)
        stepper.setCurrentStepPercentage(1, animated: false)
        XCTAssertEqual(stepper.currentStepIndex, 3)
    }

    func testFloatRoundingLandsOnIntendedStep() {
        let stepper = makeStepper(11)
        stepper.setCurrentStepPercentage(0.7, animated: false)
        XCTAssertEqual(stepper.currentStepIndex, 7)
    }

    func testPercentageIsClamped() {
        let stepper = makeStepper(3)
        stepper.setCurrentStepPercentage(2, animated: false)
        XCTAssertEqual(stepper.currentStepPercentage, 1)
        stepper.setCurrentStepPercentage(-1, animated: false)
        XCTAssertEqual(stepper.currentStepPercentage, 0)
    }

    func testSetCurrentStep() {
        let stepper = makeStepper(5)
        stepper.setCurrentStep(2, animated: false)
        XCTAssertEqual(stepper.currentStepPercentage, 0.5)
        XCTAssertEqual(stepper.currentStepIndex, 2)
        XCTAssertEqual(items(stepper).map { $0.indicatorView.image }, [completed, completed, completed, incomplete, incomplete])
        stepper.setCurrentStep(99, animated: false)
        XCTAssertEqual(stepper.currentStepIndex, 4)
    }

    func testEmptyAndSingleStepDoNotCrash() {
        let empty = makeStepper(0)
        XCTAssertNil(empty.currentStepIndex)
        empty.setCurrentStep(3)
        empty.setCurrentStepPercentage(0.5)

        let single = makeStepper(1)
        single.setCurrentStep(0)
        XCTAssertEqual(single.currentStepIndex, 0)
    }

    func testChangingStepsRebuildsItems() {
        let stepper = makeStepper(2)
        stepper.steps = ["A", "B", "C"]
        XCTAssertEqual(items(stepper).map { $0.titleLabel.text }, ["A", "B", "C"])
    }

    func testStylingUpdatesInPlace() {
        let stepper = makeStepper(3)
        let before = items(stepper)
        stepper.completedLabelColor = .red
        stepper.indicatorSize = 40
        stepper.progressHeight = 4
        stepper.layoutIfNeeded()
        XCTAssertTrue(zip(before, items(stepper)).allSatisfy { $0 === $1 }, "Styling should not recreate step views")
        XCTAssertEqual(before[0].titleLabel.textColor, .red)
        XCTAssertEqual(before[0].indicatorView.bounds.width, 40)
    }

    func testProgressBarSpansFirstToLastIndicator() {
        let stepper = makeStepper(4)
        let progress = stepper.subviews.compactMap { $0 as? UIProgressView }.first!
        let all = items(stepper)
        let firstCenter = all.first!.indicatorView.convert(all.first!.indicatorView.bounds, to: stepper).midX
        let lastCenter = all.last!.indicatorView.convert(all.last!.indicatorView.bounds, to: stepper).midX
        XCTAssertEqual(progress.frame.minX, firstCenter, accuracy: 0.5)
        XCTAssertEqual(progress.frame.maxX, lastCenter, accuracy: 0.5)
    }

    func testAccessibility() {
        let stepper = makeStepper(2)
        let all = items(stepper)
        XCTAssertEqual(all[0].accessibilityLabel, "Step 1")
        XCTAssertEqual(all[0].accessibilityValue, "Completed")
        XCTAssertEqual(all[1].accessibilityValue, "Not completed")
    }
}
