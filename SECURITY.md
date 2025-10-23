# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Features

ClauseWise implements several security measures to protect your data:

### 1. AES Encryption
All uploaded documents are encrypted using AES (Advanced Encryption Standard) before being stored locally on your device. This ensures that even if someone gains access to your device storage, they cannot read your contracts without the encryption key.

### 2. Local Storage Only
Your contracts are stored locally on your device using Hive, a secure NoSQL database. Documents are never uploaded to our servers (except temporarily to AI providers for analysis).

### 3. API Key Security
Your OpenAI/Mistral API keys are:
- Stored locally on your device
- Encrypted at rest
- Never transmitted to our servers
- Only used for direct communication with AI providers

### 4. Data Privacy
- No user tracking or analytics
- No cloud backup of your documents
- No sharing of your data with third parties (except AI providers for analysis)
- All processing happens on your device or directly with AI providers

## Reporting a Vulnerability

If you discover a security vulnerability in ClauseWise, please help us protect our users by responsibly disclosing it.

**Please do NOT:**
- Create a public GitHub issue for the vulnerability
- Discuss the vulnerability in public forums

**Please DO:**
1. Email security@clausewise.app with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

2. Allow us reasonable time to respond and fix the issue before public disclosure

We take security seriously and will respond to vulnerability reports within 48 hours.

## Security Best Practices for Users

1. **Keep your device secure**
   - Use device lock screen
   - Keep your OS and apps updated
   - Don't share your device with untrusted users

2. **Protect your API keys**
   - Never share your OpenAI/Mistral API keys
   - Rotate keys periodically
   - Monitor API usage for suspicious activity

3. **Be cautious with sensitive documents**
   - Remember that documents are sent to AI providers for analysis
   - Don't upload documents with extremely sensitive information if you're unsure
   - Review AI provider terms of service and privacy policies

4. **Regular backups**
   - While data is stored locally, ensure you have device backups
   - Use the app's export feature to save important analyses

## Third-Party Services

ClauseWise integrates with:
- **OpenAI**: For GPT-4 powered analysis
- **Mistral AI**: Alternative AI provider

Please review their security and privacy policies:
- [OpenAI Privacy Policy](https://openai.com/privacy/)
- [Mistral AI Privacy Policy](https://mistral.ai/privacy/)

## Updates

This security policy is subject to updates. Major changes will be announced in release notes.

Last updated: 2024-10-23
