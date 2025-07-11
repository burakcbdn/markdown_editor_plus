import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../src/toolbar.dart';
import 'modal_select_emoji.dart';
import 'modal_input_url.dart';
import 'toolbar_item.dart';

/// Enum defining all possible markdown toolbar actions
enum MarkdownToolbarAction {
  preview,
  clear,
  reset,
  selectSingleLine,
  bold,
  italic,
  strikethrough,
  heading,
  unorderedList,
  checkboxList,
  emoji,
  link,
  image,
  blockquote,
  code,
  horizontalLine,
}

class MarkdownToolbar extends StatelessWidget {
  /// Preview/Eye button
  final VoidCallback? onPreviewChanged;
  final TextEditingController controller;
  final VoidCallback? unfocus;
  final bool emojiConvert;
  final bool autoCloseAfterSelectEmoji;
  final Toolbar toolbar;
  final Color? toolbarBackground;
  final Color? expandableBackground;
  final bool showPreviewButton;
  final bool showEmojiSelection;
  final VoidCallback? onActionCompleted;
  final String? markdownSyntax;
  final Set<MarkdownToolbarAction> visibleActions;

  /// Custom action widgets to be displayed at the end of the toolbar
  final List<Widget> customActions;

  const MarkdownToolbar({
    super.key,
    this.onPreviewChanged,
    this.markdownSyntax,
    required this.controller,
    this.emojiConvert = true,
    this.unfocus,
    required this.toolbar,
    this.autoCloseAfterSelectEmoji = true,
    this.toolbarBackground,
    this.expandableBackground,
    this.onActionCompleted,
    this.showPreviewButton = true,
    this.showEmojiSelection = true,
    this.customActions = const [],
    this.visibleActions = const {
      MarkdownToolbarAction.preview,
      MarkdownToolbarAction.clear,
      MarkdownToolbarAction.reset,
      MarkdownToolbarAction.selectSingleLine,
      MarkdownToolbarAction.bold,
      MarkdownToolbarAction.italic,
      MarkdownToolbarAction.strikethrough,
      MarkdownToolbarAction.heading,
      MarkdownToolbarAction.unorderedList,
      MarkdownToolbarAction.checkboxList,
      MarkdownToolbarAction.emoji,
      MarkdownToolbarAction.link,
      MarkdownToolbarAction.image,
      MarkdownToolbarAction.blockquote,
      MarkdownToolbarAction.code,
      MarkdownToolbarAction.horizontalLine,
    },
  });

  // Helper method to handle actions and maintain focus
  void _handleAction(VoidCallback action) {
    // Perform the action - note that Toolbar.action already handles focus internally
    action();

    // Call the completion callback if provided - this should help maintain focus in parent
    onActionCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: toolbarBackground ?? Colors.grey[200],
      width: double.maxFinite,
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // preview
                  if (visibleActions.contains(MarkdownToolbarAction.preview) &&
                      showPreviewButton)
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_view_item"),
                      icon: FontAwesomeIcons.eye,
                      onPressedButton: onPreviewChanged,
                      tooltip: 'Show/Hide markdown preview',
                    ),

                  // Clear the field
                  if (visibleActions.contains(MarkdownToolbarAction.clear))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_clear_action"),
                      icon: FontAwesomeIcons.trashCan,
                      onPressedButton: () => _handleAction(() {
                        controller.clear();
                      }),
                      tooltip: 'Clear the text field',
                    ),

                  // Reset the text field
                  if (visibleActions.contains(MarkdownToolbarAction.reset))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_reset_action"),
                      icon: FontAwesomeIcons.arrowRotateLeft,
                      onPressedButton: () {
                        if (markdownSyntax != null) {
                          _handleAction(() {
                            controller.text = markdownSyntax!;
                          });
                        }
                      },
                      tooltip: 'Reset the text field to specified format',
                    ),

                  // select single line
                  if (visibleActions
                      .contains(MarkdownToolbarAction.selectSingleLine))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_selection_action"),
                      icon: FontAwesomeIcons.textWidth,
                      onPressedButton: () => _handleAction(() {
                        toolbar.selectSingleLine.call();
                      }),
                      tooltip: 'Select single line',
                    ),
                  // bold
                  if (visibleActions.contains(MarkdownToolbarAction.bold))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_bold_action"),
                      icon: FontAwesomeIcons.bold,
                      tooltip: 'Make text bold',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("**", "**");
                      }),
                    ),
                  // italic
                  if (visibleActions.contains(MarkdownToolbarAction.italic))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_italic_action"),
                      icon: FontAwesomeIcons.italic,
                      tooltip: 'Make text italic',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("_", "_");
                      }),
                    ),
                  // strikethrough
                  if (visibleActions
                      .contains(MarkdownToolbarAction.strikethrough))
                    ToolbarItem(
                      key: const ValueKey<String>(
                          "toolbar_strikethrough_action"),
                      icon: FontAwesomeIcons.strikethrough,
                      tooltip: 'Strikethrough',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("~~", "~~");
                      }),
                    ),
                  // heading
                  if (visibleActions.contains(MarkdownToolbarAction.heading))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_heading_action"),
                      icon: FontAwesomeIcons.heading,
                      isExpandable: true,
                      tooltip: 'Insert Heading',
                      expandableBackground: expandableBackground,
                      items: [
                        ToolbarItem(
                          key: const ValueKey<String>("h1"),
                          icon: "H1",
                          tooltip: 'Insert Heading 1',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("# ", "");
                          }),
                        ),
                        ToolbarItem(
                          key: const ValueKey<String>("h2"),
                          icon: "H2",
                          tooltip: 'Insert Heading 2',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("## ", "");
                          }),
                        ),
                        ToolbarItem(
                          key: const ValueKey<String>("h3"),
                          icon: "H3",
                          tooltip: 'Insert Heading 3',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("### ", "");
                          }),
                        ),
                        ToolbarItem(
                          key: const ValueKey<String>("h4"),
                          icon: "H4",
                          tooltip: 'Insert Heading 4',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("#### ", "");
                          }),
                        ),
                        // Heading 5 onwards has same font
                      ],
                    ),
                  // unorder list
                  if (visibleActions
                      .contains(MarkdownToolbarAction.unorderedList))
                    ToolbarItem(
                      key:
                          const ValueKey<String>("toolbar_unorder_list_action"),
                      icon: FontAwesomeIcons.listUl,
                      tooltip: 'Unordered list',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("* ", "");
                      }),
                    ),
                  // checkbox list
                  if (visibleActions
                      .contains(MarkdownToolbarAction.checkboxList))
                    ToolbarItem(
                      key: const ValueKey<String>(
                          "toolbar_checkbox_list_action"),
                      icon: FontAwesomeIcons.listCheck,
                      isExpandable: true,
                      expandableBackground: expandableBackground,
                      items: [
                        ToolbarItem(
                          key: const ValueKey<String>("checkbox"),
                          icon: FontAwesomeIcons.solidSquareCheck,
                          tooltip: 'Checked checkbox',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("- [x] ", "");
                          }),
                        ),
                        ToolbarItem(
                          key: const ValueKey<String>("uncheckbox"),
                          icon: FontAwesomeIcons.square,
                          tooltip: 'Unchecked checkbox',
                          onPressedButton: () => _handleAction(() {
                            toolbar.action("- [ ] ", "");
                          }),
                        )
                      ],
                    ),
                  // emoji
                  if (visibleActions.contains(MarkdownToolbarAction.emoji) &&
                      showEmojiSelection)
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_emoji_action"),
                      icon: FontAwesomeIcons.faceSmile,
                      tooltip: 'Select emoji',
                      onPressedButton: () async {
                        await _showModalSelectEmoji(
                            context, controller.selection);
                      },
                    ),
                  // link
                  if (visibleActions.contains(MarkdownToolbarAction.link))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_link_action"),
                      icon: FontAwesomeIcons.link,
                      tooltip: 'Add hyperlink',
                      onPressedButton: () async {
                        if (toolbar.hasSelection) {
                          _handleAction(() {
                            toolbar.action(
                                "[enter link description here](", ")");
                          });
                        } else {
                          await _showModalInputUrl(
                              context,
                              "[enter link description here](",
                              controller.selection);
                        }
                      },
                    ),
                  // image
                  if (visibleActions.contains(MarkdownToolbarAction.image))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_image_action"),
                      icon: FontAwesomeIcons.image,
                      tooltip: 'Add image',
                      onPressedButton: () async {
                        if (toolbar.hasSelection) {
                          _handleAction(() {
                            toolbar.action(
                                "![enter image description here](", ")");
                          });
                        } else {
                          await _showModalInputUrl(
                            context,
                            "![enter image description here](",
                            controller.selection,
                          );
                        }
                      },
                    ),
                  // blockquote
                  if (visibleActions.contains(MarkdownToolbarAction.blockquote))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_blockquote_action"),
                      icon: FontAwesomeIcons.quoteLeft,
                      tooltip: 'Blockquote',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("> ", "");
                      }),
                    ),
                  // code
                  if (visibleActions.contains(MarkdownToolbarAction.code))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_code_action"),
                      icon: FontAwesomeIcons.code,
                      tooltip: 'Code syntax/font',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("`", "`");
                      }),
                    ),
                  // line
                  if (visibleActions
                      .contains(MarkdownToolbarAction.horizontalLine))
                    ToolbarItem(
                      key: const ValueKey<String>("toolbar_line_action"),
                      icon: FontAwesomeIcons.rulerHorizontal,
                      tooltip: 'Add line',
                      onPressedButton: () => _handleAction(() {
                        toolbar.action("\n___\n", "");
                      }),
                    ),
                ],
              ),
            ),
          ),

          // Add custom actions at the end
          ...customActions,
        ],
      ),
    );
  }

  // Show modal to select emoji
  Future<dynamic> _showModalSelectEmoji(
      BuildContext context, TextSelection selection) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return ModalSelectEmoji(
          emojiConvert: emojiConvert,
          onChanged: (String emot) {
            if (autoCloseAfterSelectEmoji) Navigator.pop(context);
            final newSelection = toolbar.getSelection(selection);

            toolbar.action(emot, "", textSelection: newSelection);
            // change selection baseoffset if not auto close emoji
            if (!autoCloseAfterSelectEmoji) {
              selection = TextSelection.collapsed(
                offset: newSelection.baseOffset + emot.length,
              );
              unfocus?.call();
            }
            onActionCompleted?.call();
          },
        );
      },
    );
  }

  // show modal input
  Future<dynamic> _showModalInputUrl(
    BuildContext context,
    String leftText,
    TextSelection selection,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ModalInputUrl(
          toolbar: toolbar,
          leftText: leftText,
          selection: selection,
          onActionCompleted: onActionCompleted,
        );
      },
    );
  }
}
