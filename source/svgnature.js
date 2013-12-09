// Generated by CoffeeScript 1.3.3
(function() {
  var __slice = [].slice;

  (function($, window, document) {
    var Svgnature;
    Svgnature = (function() {

      function Svgnature(el, settings) {
        this.settings = settings;
        this.paper = Raphael(el);
        this.coords = '';
        $(el).on('mousedown', this.drawStart).on('mouseup', this.drawEnd).on('mousemove', this.move).on('touchstart', this.drawStart).on('touchend', this.drawEnd).on('touchmove', this.move);
      }

      Svgnature.prototype.getCoords = function(e) {
        var _ref;
        if (e.touches) {
          return {
            x: e.touches[0].clientX,
            y: e.touches[0].clientY
          };
        } else if (((_ref = e.originalEvent) != null ? _ref.touches : void 0) != null) {
          return {
            x: e.originalEvent.touches[0].clientX,
            y: e.originalEvent.touches[0].clientY
          };
        } else {
          return {
            x: e.offsetX,
            y: e.offsetY
          };
        }
      };

      Svgnature.prototype.drawStart = function(e) {
        return $(this).data('svgnature').initializeLine(e);
      };

      Svgnature.prototype.move = function(e) {
        e.preventDefault();
        return $(this).data('svgnature').drawLine(e);
      };

      Svgnature.prototype.drawEnd = function(e) {
        return $(this).data('svgnature').drawing = false;
      };

      Svgnature.prototype.initializeLine = function(e) {
        this.drawing = true;
        this.path || (this.path = this.paper.path().attr(this.settings));
        return this.setNextCoord('M', this.getCoords(e));
      };

      Svgnature.prototype.drawLine = function(e) {
        if (this.drawing) {
          this.setNextCoord('L', this.getCoords(e));
          return this.path.attr('path', this.getPath());
        }
      };

      Svgnature.prototype.setNextCoord = function(command, coords) {
        return this.coords = "" + this.coords + command + coords.x + "," + coords.y;
      };

      Svgnature.prototype.addPath = function(path) {
        this.coords = "" + this.coords + path;
        this.path.attr('path', this.coords);
        return true;
      };

      Svgnature.prototype.getPath = function() {
        return this.coords;
      };

      Svgnature.prototype.clearPath = function() {
        this.coords = '';
        this.path.attr('path', '');
        return true;
      };

      Svgnature.prototype.getURI = function() {
        var dom, serializer;
        dom = $(this.paper.canvas).attr('xmlns:xlink', 'http://www.w3.org/1999/xlink')[0];
        serializer = new XMLSerializer;
        return "data:image/svg+xml;utf8," + (serializer.serializeToString(dom));
      };

      return Svgnature;

    })();
    return $.fn.svgnature = function() {
      var args, method;
      method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return $(this).map(function(i, el) {
        var defaults, settings, svgnature;
        svgnature = $(el).data('svgnature');
        if (method === 'getURI') {
          return svgnature.getURI();
        } else if (method === 'getPath') {
          return svgnature.getPath();
        } else if (method === 'addPath') {
          return svgnature.addPath(args[i]);
        } else if (method === 'clearPath') {
          return svgnature.clearPath();
        } else {
          defaults = {
            'stroke': '#000',
            'stroke-width': '2'
          };
          settings = $.extend(defaults, method);
          return $(el).data('svgnature', new Svgnature(el, settings));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);
