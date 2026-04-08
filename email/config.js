function normalizeEmail(value, fallback) {
  const normalized = String(value || '').trim();
  return normalized || fallback;
}

const DEFAULT_FROM_EMAIL = 'platform@linkcrew.io';
const DEFAULT_FROM_NAME = 'LinkCrew';
const DEFAULT_ALERT_FROM_NAME = 'LinkCrew Alerts';

const EMAIL_FROM_ADDRESS = normalizeEmail(
  process.env.EMAIL_FROM_ADDRESS || process.env.RESEND_FROM_EMAIL,
  DEFAULT_FROM_EMAIL
);
const ALERT_EMAIL_FROM_ADDRESS = normalizeEmail(
  process.env.ALERT_EMAIL_FROM_ADDRESS || process.env.RESEND_ALERT_FROM_EMAIL,
  EMAIL_FROM_ADDRESS
);
const EMAIL_FROM_NAME = normalizeEmail(process.env.EMAIL_FROM_NAME, DEFAULT_FROM_NAME);
const ALERT_EMAIL_FROM_NAME = normalizeEmail(process.env.ALERT_EMAIL_FROM_NAME, DEFAULT_ALERT_FROM_NAME);
const SUPPORT_EMAIL = normalizeEmail(process.env.SUPPORT_EMAIL || process.env.EMAIL_REPLY_TO, EMAIL_FROM_ADDRESS);

function formatFrom(name, email) {
  return `${name} <${email}>`;
}

const LINKCREW_FROM = formatFrom(EMAIL_FROM_NAME, EMAIL_FROM_ADDRESS);
const LINKCREW_ALERT_FROM = formatFrom(ALERT_EMAIL_FROM_NAME, ALERT_EMAIL_FROM_ADDRESS);

module.exports = {
  EMAIL_FROM_ADDRESS,
  ALERT_EMAIL_FROM_ADDRESS,
  EMAIL_FROM_NAME,
  ALERT_EMAIL_FROM_NAME,
  SUPPORT_EMAIL,
  LINKCREW_FROM,
  LINKCREW_ALERT_FROM,
  formatFrom,
};
