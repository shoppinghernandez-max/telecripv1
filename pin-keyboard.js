/**
 * PIN Keyboard Component
 * Creates a mobile-friendly PIN input with custom numeric keypad
 */
class PinKeyboard {
  constructor(container, options = {}) {
    this.container = container;
    this.maxDigits = options.maxDigits || 6;
    this.onComplete = options.onComplete || null;
    this.value = '';
    this.create();
  }

  create() {
    // Create wrapper
    this.wrapper = document.createElement('div');
    this.wrapper.className = 'pin-keyboard-wrapper';

    // Create input display
    this.inputDisplay = document.createElement('div');
    this.inputDisplay.className = 'pin-input-display';
    
    this.dotsContainer = document.createElement('div');
    this.dotsContainer.className = 'pin-dots-container';
    this.dotsContainer.setAttribute('aria-label', 'Ingrese su PIN');
    
    for (let i = 0; i < this.maxDigits; i++) {
      const dot = document.createElement('span');
      dot.className = 'pin-dot';
      dot.dataset.index = i;
      this.dotsContainer.appendChild(dot);
    }
    
    this.inputDisplay.appendChild(this.dotsContainer);
    this.wrapper.appendChild(this.inputDisplay);

    // Create keyboard
    this.keyboard = document.createElement('div');
    this.keyboard.className = 'pin-keyboard';

    const keys = [
      { value: '8', type: 'number' },
      { value: '2', type: 'number' },
      { value: '1', type: 'number' },
      { value: '0', type: 'number' },
      { value: '9', type: 'number' },
      { value: '4', type: 'number' },
      { value: '3', type: 'number' },
      { value: '5', type: 'number' },
      { value: 'trash', type: 'action', label: '🗑' },
      { value: '6', type: 'number' },
      { value: '7', type: 'number' },
      { value: 'backspace', type: 'action', label: '⌫' },
    ];

    keys.forEach(key => {
      const btn = document.createElement('button');
      btn.className = `pin-key ${key.type === 'action' ? 'pin-key-action' : ''}`;
      btn.textContent = key.label || key.value;
      btn.setAttribute('type', 'button');
      
      if (key.type === 'number') {
        btn.dataset.value = key.value;
      } else if (key.value === 'backspace') {
        btn.dataset.action = 'backspace';
        btn.setAttribute('aria-label', 'Borrar último dígito');
      } else if (key.value === 'trash') {
        btn.dataset.action = 'trash';
        btn.setAttribute('aria-label', 'Borrar todo');
      }

      btn.addEventListener('click', () => this.handleKeyPress(key));
      this.keyboard.appendChild(btn);
    });

    this.wrapper.appendChild(this.keyboard);
    this.container.appendChild(this.wrapper);
  }

  handleKeyPress(key) {
    if (key.type === 'number') {
      if (this.value.length < this.maxDigits) {
        this.value += key.value;
        this.updateDisplay();
        if (this.value.length === this.maxDigits && this.onComplete) {
          this.onComplete(this.value);
        }
      }
    } else if (key.value === 'backspace') {
      this.value = this.value.slice(0, -1);
      this.updateDisplay();
    } else if (key.value === 'trash') {
      this.value = '';
      this.updateDisplay();
    }
  }

  updateDisplay() {
    const dots = this.dotsContainer.querySelectorAll('.pin-dot');
    dots.forEach((dot, index) => {
      if (index < this.value.length) {
        dot.classList.add('filled');
        dot.textContent = '●';
      } else {
        dot.classList.remove('filled');
        dot.textContent = '';
      }
    });
  }

  getValue() {
    return this.value;
  }

  reset() {
    this.value = '';
    this.updateDisplay();
  }
}
