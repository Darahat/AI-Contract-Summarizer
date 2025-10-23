# API Setup Guide

This guide will help you set up the necessary API keys for ClauseWise.

## OpenAI API Setup

### Step 1: Create an OpenAI Account
1. Go to [platform.openai.com](https://platform.openai.com)
2. Sign up for an account or log in
3. Complete the verification process

### Step 2: Generate an API Key
1. Navigate to [API Keys](https://platform.openai.com/api-keys)
2. Click "Create new secret key"
3. Give your key a name (e.g., "ClauseWise")
4. Copy the key immediately (you won't be able to see it again)

### Step 3: Add Credits
1. Go to [Billing](https://platform.openai.com/account/billing)
2. Add payment method
3. Purchase credits or set up auto-reload
4. Recommended: Start with $10-20 credits

### Step 4: Configure in ClauseWise
1. Open ClauseWise app
2. Go to Settings
3. Enter your API key in "OpenAI API Key" field
4. Or enter it when uploading your first contract

### Pricing (as of 2024)
- **GPT-4**: ~$0.03 per 1K tokens input, ~$0.06 per 1K tokens output
- Average contract analysis: $0.10 - $0.50 per document
- With Free plan (2 docs/month): ~$0.20-1.00/month in API costs
- With Pro plan (unlimited): Varies based on usage

## Alternative: Mistral AI Setup

### Step 1: Create a Mistral Account
1. Go to [console.mistral.ai](https://console.mistral.ai)
2. Sign up for an account
3. Verify your email

### Step 2: Generate an API Key
1. Navigate to API Keys section
2. Click "Create API Key"
3. Copy your key

### Step 3: Configure Code
Edit `lib/providers/contract_provider.dart`:
```dart
AIService(apiKey: apiKey, provider: AIProvider.mistral)
```

### Pricing (as of 2024)
- **Mistral Large**: ~$0.008 per 1K tokens input, ~$0.024 per 1K tokens output
- Generally cheaper than OpenAI
- Average contract: $0.05 - $0.30 per document

## Cost Management Tips

1. **Set Usage Limits**
   - Set monthly spending limits in OpenAI/Mistral dashboard
   - Monitor usage regularly

2. **Optimize Prompts**
   - Keep contracts concise if possible
   - Focus on key sections for analysis

3. **Use Free Plan Wisely**
   - Reserve for important contracts
   - Upgrade to Pro only when needed

4. **Monitor API Usage**
   - Check your API dashboard regularly
   - Set up billing alerts

## Security Best Practices

1. **Never Share Your API Key**
   - Don't commit keys to git
   - Don't share screenshots containing keys
   - Don't post keys in public forums

2. **Rotate Keys Regularly**
   - Change keys every 3-6 months
   - Immediately rotate if compromised

3. **Use Different Keys**
   - Use separate keys for development and production
   - Use different keys for different apps

4. **Monitor for Unusual Activity**
   - Check usage logs regularly
   - Look for unexpected spikes
   - Set up usage alerts

## Troubleshooting

### "API key invalid" Error
- Verify key is copied correctly (no extra spaces)
- Check if key has been revoked
- Ensure billing is set up on your account

### "Rate limit exceeded" Error
- You've hit API rate limits
- Wait a few minutes and try again
- Consider upgrading your OpenAI/Mistral plan

### "Insufficient credits" Error
- Add more credits to your account
- Check your billing settings
- Verify payment method is valid

### High Costs
- Review your usage in API dashboard
- Check for unnecessary repeated analyses
- Consider using a cheaper model
- Optimize prompt length

## Support

For API-related issues:
- OpenAI: [help.openai.com](https://help.openai.com)
- Mistral AI: [docs.mistral.ai](https://docs.mistral.ai)

For ClauseWise-specific issues:
- Open an issue on [GitHub](https://github.com/Darahat/AI-Contract-Summarizer/issues)
- Email: support@clausewise.app
