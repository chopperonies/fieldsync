// Entry point for Render/local runtime. Start the API first, then optionally the
// Telegram bot in the same process when bot credentials are present.
require('./api/server');

if (process.env.TELEGRAM_BOT_TOKEN && process.env.DISABLE_FIELDSYNC_TELEGRAM_BOT !== 'true') {
  require('./bot/index');
}
