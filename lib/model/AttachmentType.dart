

class AttachmentType{

  static const video = 'VIDEO';
  static const image = 'IMAGE';
  static const text = 'TEXT';
  static const voice = 'VOICE';
  static const sticker = 'STICKER';

  static messageType(String type) {
    if (type == AttachmentType.text) {
      return 'Text Message';
    } else if (type == AttachmentType.image) {
      return 'Image Message';
    } else if (type == AttachmentType.video) {
      return 'Video Message';
    }else if (type == AttachmentType.voice) {
      return 'Voice Message';
    }else if (type == AttachmentType.sticker) {
      return 'Sticker Message';
    }
    return '';
  }
}
