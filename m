Return-Path: <kernel-hardening-return-21943-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 45496C0219B
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2025 01:04:10 +0000 (UTC)
Received: (qmail 30215 invoked by uid 550); 12 Feb 2025 01:03:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15912 invoked from network); 12 Feb 2025 00:40:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739320810;
	bh=o6jacl+8YFQgDkweUrSEzGvajj1U6xTIXTLU27ON87Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=horZP85LlDZ86QCZvtw15CDgr1Mo8OW5HZQj5/HiaQVmg7YZ67A4QfVf8N8Cq+dLq
	 8lXcGDK/rJG15Bh+HNw4ajUaUcUQq1g054DSKqAk2K+VTPbsHI7RYYMoQ5d91WlVh6
	 UIYyU150aJfGduKkNmkUsfItaidd9JwO0EWrVUmQGv+XmQPTZShTS+DZcaLL4INVrv
	 eZ2DTondLlJS1nBFz3UUeJpoTdkjt8DIUy6PxJHAWvMiPmrYUJ6JZ/wjUq1Vt+Mdy2
	 J8QPCNfhSstwU+4kVTjdOZV335c5rKRylDlEuEpGdWriFbr+9QU+IqgZmwmL6UMRky
	 lP/AH5scUBhMA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] hamradio: baycom: replace strcpy() with strscpy()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173932083925.51333.16699116613029373811.git-patchwork-notify@kernel.org>
Date: Wed, 12 Feb 2025 00:40:39 +0000
References: <3qo3fbrak7undfgocsi2s74v4uyjbylpdqhie4dohfoh4welfn@joq7up65ug6v>
In-Reply-To: <3qo3fbrak7undfgocsi2s74v4uyjbylpdqhie4dohfoh4welfn@joq7up65ug6v>
To: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: dan.carpenter@linaro.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-hams@vger.kernel.org, pabeni@redhat.com,
 linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 8 Feb 2025 23:06:21 -0500 you wrote:
> The strcpy() function has been deprecated and replaced with strscpy().
> There is an effort to make this change treewide:
> https://github.com/KSPP/linux/issues/88.
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v3] hamradio: baycom: replace strcpy() with strscpy()
    https://git.kernel.org/netdev/net-next/c/3b147be9ef08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


