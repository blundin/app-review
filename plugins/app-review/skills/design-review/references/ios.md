# iOS Conventions

Judge against Apple's Human Interface Guidelines. Check these on the core path first.

## Navigation
- Top-level sections use a tab bar with five or fewer tabs; drill-down uses a navigation stack with a back button.
- The edge swipe returns to the previous screen wherever a back button appears.
- Sheets hold self-contained tasks, dismiss by swiping down, and confirm before discarding unsaved input.
- Full-screen modals are reserved for immersive or multi-step tasks and always offer a clear way out.

## Controls
- System controls (toggles, pickers, segmented controls, menus) appear wherever a custom control adds nothing.
- Destructive actions use the destructive role (red) and confirm through an alert or action sheet, or offer undo.
- Swipe actions on list rows match their meaning: a swipe to delete deletes.
- Pull to refresh appears on lists that show remote data.
- Icons come from SF Symbols where a fitting symbol exists, at weights that match nearby text.

## Layout and appearance
- Content respects safe areas on every device, including the home indicator and the Dynamic Island.
- The layout holds on the smallest and largest supported iPhones, and on iPad if the app supports it.
- Dark appearance is supported and every custom color has a dark variant.
- The keyboard never covers the field being edited or the action that submits it.

## Feedback
- Haptics accompany meaningful events (success, failure, a toggle) and nothing else.
- Long operations show progress, and work continues or resumes sensibly when the app returns from the background.

## System integration
- Permission prompts appear in context, at the moment of need, with a purpose string that says specifically why. A custom screen before the system alert is optional; when one appears, it offers only a Continue action and never mimics the system alert.
- Notifications open the exact screen they concern.

## iOS 26 and later (Liquid Glass)
- Glass belongs to the controls and navigation layer floating above content, never to content itself such as list rows or cards.
- Standard bars, tab bars, and toolbars pick up glass from the system; custom backgrounds on them that block it are a departure.
- Glass does not stack on glass, and text and icons on glass stay legible over every content behind them.
- Apps that still support earlier iOS versions show a sensible non-glass appearance there.
