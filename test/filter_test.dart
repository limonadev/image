import 'dart:io';
import 'package:image/image.dart';
import 'package:test/test.dart';

void main() {
  group('filter', () {
    var image = readJpg(File('test/res/jpg/portrait_5.jpg').readAsBytesSync());
    image = copyResize(image, width: 400);
    var image2 = readPng(File('test/res/png/alpha_edge.png').readAsBytesSync());

    test('fill', () {
      Image f = Image(10, 10, channels: Channels.rgb);
      f.fill(getColor(128, 64, 32, 255));
      File fp = File('.dart_tool/out/fill.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('fillRect', () {
      Image f = Image.from(image);
      fillRect(f, 50, 50, 150, 150, getColor(128, 255, 128, 255));
      fillRect(f, 250, -10, 100, 750, getColor(255, 128, 128, 128));
      File fp = File('.dart_tool/out/fillRect.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('floodFill', () {
      Image s = readJpg(File('test/res/oblique.jpg').readAsBytesSync());
      int c = s.getPixel(50, 50);
      fillFlood(s, 50, 50, c, threshold: 15.6);
      File fp = File('.dart_tool/out/fillFlood.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(s));
    });

    test('copyRectify', () {
      Image s = readJpg(File('test/res/oblique.jpg').readAsBytesSync());
      Image d = Image(92, 119);
      copyRectify(s,
          topLeft: Point(16, 32),
          topRight: Point(79, 39),
          bottomLeft: Point(16, 151),
          bottomRight: Point(108, 141),
          toImage: d);
      File fp = File('.dart_tool/out/oblique.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(d));
    });

    test('copyInto', () {
      Image s = Image.from(image);
      Image d =
          Image(image.width + 20, image.height + 20, channels: image.channels);
      fill(d, 0xff0000ff);
      copyInto(d, s, dstX: 10, dstY: 10);
      copyInto(d, image2, dstX: 10, dstY: 10);

      File('.dart_tool/out/copyInto.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writeJpg(d));
    });

    test('add', () {
      Image i1 = Image.from(image);
      Image i2 = Image.from(image2);
      i1 += i2;

      File fp = File('.dart_tool/out/add.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(i1));
    });

    test('sub', () {
      Image i1 = Image.from(image);
      Image i2 = Image.from(image2);
      i1 -= i2;

      File fp = File('.dart_tool/out/sub.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(i1));
    });

    test('or', () {
      Image i1 = Image.from(image);
      Image i2 = Image.from(image2);
      i1 |= i2;

      File fp = File('.dart_tool/out/or.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(i1));
    });

    test('and', () {
      Image i1 = Image.from(image);
      Image i2 = Image.from(image2);
      i1 &= i2;

      File fp = File('.dart_tool/out/and.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(i1));
    });

    test('draw shapes', () {
      Image f = Image.from(image);
      int c1 = getColor(128, 255, 128, 255);
      drawLine(f, 0, 0, f.width, f.height, c1, thickness: 3);
      int c2 = getColor(255, 128, 128, 255);
      drawLine(f, f.width, 0, 0, f.height, c2, thickness: 5, antialias: true);
      drawCircle(f, 100, 100, 50, c1);
      drawRect(f, 50, 50, 150, 150, c2);

      File fp = File('.dart_tool/out/drawShapes.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('brightness', () {
      Image f = Image.from(image);
      brightness(f, 100);
      File fp = File('.dart_tool/out/brightness.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('copyResize', () {
      Image f = copyResize(image, height: 100);
      expect(f.height, equals(100));
      File fp = File('.dart_tool/out/copyResize.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('colorOffset', () {
      Image f = Image.from(image);
      colorOffset(f, red: 5);

      File('.dart_tool/out/colorOffset.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writeJpg(f));

      f = Image(48, 48);
      colorOffset(f, red: 255);
      File('.dart_tool/out/colorOffset_red.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writeJpg(f));

      f = Image(48, 48);
      colorOffset(f, green: 255);
      File('.dart_tool/out/colorOffset_green.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writeJpg(f));

      f = Image(48, 48);
      colorOffset(f, blue: 255);
      File('.dart_tool/out/colorOffset_blue.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writeJpg(f));
    });

    test('contrast', () {
      Image f = Image.from(image);
      contrast(f, 150);

      File fp = File('.dart_tool/out/contrast.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('adjustColor:saturation', () {
      Image f = Image.from(image);
      adjustColor(f, saturation: 0.35);

      File fp = File('.dart_tool/out/adjustColor_saturation.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('adjustColor:gamma', () {
      Image f = Image.from(image);
      adjustColor(f, gamma: 1.0 / 2.2);

      File fp = File('.dart_tool/out/adjustColor_gamma.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('adjustColor:hue', () {
      Image f = Image.from(image);
      adjustColor(f, hue: 75.0, gamma: 0.75, amount: 0.35);

      File fp = File('.dart_tool/out/adjustColor_hue.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('emboss', () {
      Image f = Image.from(image);
      emboss(f);

      File fp = File('.dart_tool/out/emboss.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('sobel', () {
      var f = readPng(File('test/res/png/lenna.png').readAsBytesSync());
      sobel(f);

      File fp = File('.dart_tool/out/sobel.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('gaussianBlur', () {
      Image f = Image.from(image);
      gaussianBlur(f, 10);

      File fp = File('.dart_tool/out/gaussianBlur.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('grayscale', () {
      Image f = Image.from(image);
      grayscale(f);

      File fp = File('.dart_tool/out/grayscale.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('invert', () {
      Image f = Image.from(image);
      invert(f);

      File fp = File('.dart_tool/out/invert.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('NOISE_GAUSSIAN', () {
      Image f = Image.from(image);
      noise(f, 10.0, type: NoiseType.gaussian);

      File fp = File('.dart_tool/out/noise_gaussian.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('NOISE_UNIFORM', () {
      Image f = Image.from(image);
      noise(f, 10.0, type: NoiseType.uniform);

      File fp = File('.dart_tool/out/noise_uniform.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('NOISE_SALT_PEPPER', () {
      Image f = Image.from(image);
      noise(f, 10.0, type: NoiseType.salt_pepper);

      File fp = File('.dart_tool/out/noise_salt_pepper.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('NOISE_POISSON', () {
      Image f = Image.from(image);
      noise(f, 10.0, type: NoiseType.poisson);

      File fp = File('.dart_tool/out/noise_poisson.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('NOISE_RICE', () {
      Image f = Image.from(image);
      noise(f, 10.0, type: NoiseType.rice);

      File fp = File('.dart_tool/out/noise_rice.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('normalize', () {
      Image f = Image.from(image);
      normalize(f, 100, 255);

      File fp = File('.dart_tool/out/normalize.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('pixelate', () {
      Image f = Image.from(image);
      pixelate(f, 20, mode: PixelateMode.upperLeft);

      File fp = File('.dart_tool/out/PIXELATE_UPPERLEFT.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));

      f = Image.from(image);
      pixelate(f, 20, mode: PixelateMode.average);

      fp = File('.dart_tool/out/PIXELATE_AVERAGE.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('remapColors', () {
      Image f = Image.from(image);
      f.channels = Channels.rgba;
      remapColors(f,
          red: Channel.green, green: Channel.red, alpha: Channel.luminance);

      File fp = File('.dart_tool/out/remapColors.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('rotate_90', () {
      Image f = Image.from(image);
      Image r = copyRotate(f, 90);

      File fp = File('.dart_tool/out/rotate_90.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });

    test('rotate_180', () {
      Image f = Image.from(image);
      Image r = copyRotate(f, 180);

      File fp = File('.dart_tool/out/rotate_180.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });

    test('rotate_270', () {
      Image f = Image.from(image);
      Image r = copyRotate(f, 270);

      File fp = File('.dart_tool/out/rotate_270.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });

    test('rotate_45', () {
      Image f = Image.from(image);
      f = copyRotate(f, 45);

      File fp = File('.dart_tool/out/rotate_45.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('smooth', () {
      Image f = Image.from(image);
      smooth(f, 10);

      File fp = File('.dart_tool/out/smooth.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('sepia', () {
      Image f = Image.from(image);
      sepia(f);

      File fp = File('.dart_tool/out/sepia.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('vignette', () {
      Image f = Image.from(image);
      vignette(f);

      File fp = File('.dart_tool/out/vignette.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('octree quantize', () {
      var f = readPng(File('test/res/png/lenna.png').readAsBytesSync());

      quantize(f, numberOfColors: 16, method: QuantizeMethod.octree);
      var colors = Set<int>();
      for (int y = 0; y < f.height; ++y) {
        for (int x = 0; x < f.width; ++x) {
          colors.add(f.getPixel(x, y));
        }
      }
      File fp = File('.dart_tool/out/quantize_octree.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('neural quantize', () {
      var f = readPng(File('test/res/png/lenna.png').readAsBytesSync());

      quantize(f, numberOfColors: 16, method: QuantizeMethod.neuralNet);
      var colors = Set<int>();
      for (int y = 0; y < f.height; ++y) {
        for (int x = 0; x < f.width; ++x) {
          colors.add(f.getPixel(x, y));
        }
      }
      File fp = File('.dart_tool/out/quantize_neural.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(f));
    });

    test('trim', () {
      Image image = readPng(File('test/res/png/trim.png').readAsBytesSync());
      Image trimmed = trim(image, mode: TrimMode.transparent);
      File('.dart_tool/out/trim.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(trimmed));
      expect(trimmed.width, equals(64));
      expect(trimmed.height, equals(56));

      trimmed = trim(image, mode: TrimMode.topLeftColor);
      File('.dart_tool/out/trim_topLeftColor.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(trimmed));
      expect(trimmed.width, equals(64));
      expect(trimmed.height, equals(56));

      trimmed = trim(image, mode: TrimMode.bottomRightColor);
      File('.dart_tool/out/trim_bottomRightColor.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(trimmed));
      expect(trimmed.width, equals(64));
      expect(trimmed.height, equals(56));
    });

    test('dropShadow', () {
      Image s = Image.from(image2);
      Image d = dropShadow(s, 5, 5, 10);

      File('.dart_tool/out/dropShadow.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(d));

      s = Image.from(image2);
      d = dropShadow(s, -5, 5, 10);

      File('.dart_tool/out/dropShadow-2.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(d));

      s = Image.from(image2);
      d = dropShadow(s, 5, -5, 10);

      File('.dart_tool/out/dropShadow-3.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(d));

      s = Image.from(image2);
      d = dropShadow(s, -5, -5, 10);

      File('.dart_tool/out/dropShadow-4.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(d));

      s = Image(256, 256);
      s.fill(0);
      drawString(s, arial_48, 30, 100, 'Shadow', color: getColor(255, 0, 0));
      d = dropShadow(s, -3, -3, 5);

      File('.dart_tool/out/dropShadow-5.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(writePng(d));
    });

    test('flip horizontal', () {
      Image f = Image.from(image);
      Image r = flip(f, Flip.horizontal);

      File fp = File('.dart_tool/out/flipH.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });
    test('flip vertical', () {
      Image f = Image.from(image);
      Image r = flip(f, Flip.vertical);

      File fp = File('.dart_tool/out/flipV.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });

    test('flip both', () {
      Image f = Image.from(image);
      Image r = flip(f, Flip.both);

      File fp = File('.dart_tool/out/flipHV.jpg');
      fp.createSync(recursive: true);
      fp.writeAsBytesSync(writeJpg(r));
    });
  });
}
