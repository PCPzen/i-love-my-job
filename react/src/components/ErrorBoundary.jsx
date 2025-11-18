import React from 'react';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null, info: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, info) {
    // You can also log the error to an external service here
    this.setState({ error, info });
    // eslint-disable-next-line no-console
    console.error('ErrorBoundary caught an error', error, info);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ padding: 24, fontFamily: 'sans-serif' }}>
          <h2>เกิดข้อผิดพลาดภายในแอป (Error)</h2>
          <pre style={{ whiteSpace: 'pre-wrap', background: '#fff6f6', color: '#900', padding: 12, borderRadius: 6 }}>
            {String(this.state.error && this.state.error.toString())}
            {this.state.info && this.state.info.componentStack}
          </pre>
          <p>ดูคอนโซลของเบราว์เซอร์หรือเทอร์มินัลสำหรับ stack trace เพิ่มเติม</p>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
