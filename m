Return-Path: <kernel-hardening-return-21517-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 10FE1C433EF
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Dec 2021 12:59:17 +0000 (UTC)
Received: (qmail 23727 invoked by uid 550); 7 Dec 2021 12:59:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30717 invoked from network); 7 Dec 2021 00:40:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1638837609;
	bh=B1VP9aKvVrC9MoNBK1NK+od8ypE7G0li6i9pIJat0sU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iHyFioOoBkwE/8kBLe2fqk6Lj/YKw6o3VdJokq/HuOUouG6orBI6FgQH9hoyBE+rb
	 zdF/52MjpLbKw105fPRvsDfzUugZhg9gbUPIhA3wcPrApODlbHEiQpkANEfEbFwiDX
	 cmo3sHyN/rr4m0NZEJt5iu67shF2A4KuEzR5RFGcTsi9e5ZCjySpEhtpki7+6DEK2C
	 0aHas4fCeN5Cq6kwEKbqyqk8CTtUvojoFZy/jsUZV7uFuPp/dOHhanqsHpSE3BSFQr
	 0+Jsbi9egAaYtCE+4iEkNnTeWrnHr4Ik9suicjYs1r2IrX3VzIukkXiO/wnCKTHqR+
	 Gw2qFmnTw/ypg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: prestera: replace zero-length array with flexible-array
 member
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <163883760975.11691.18220065065431409581.git-patchwork-notify@kernel.org>
Date: Tue, 07 Dec 2021 00:40:09 +0000
References: <20211204171349.22776-1-jose.exposito89@gmail.com>
In-Reply-To: <20211204171349.22776-1-jose.exposito89@gmail.com>
To: =?utf-8?b?Sm9zw6kgRXhww7NzaXRvIDxqb3NlLmV4cG9zaXRvODlAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc: tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com,
 gustavoars@kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Dec 2021 18:13:49 +0100 you wrote:
> One-element and zero-length arrays are deprecated and should be
> replaced with flexible-array members:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper.
> 
> [...]

Here is the summary with links:
  - net: prestera: replace zero-length array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/01081be1ea8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


