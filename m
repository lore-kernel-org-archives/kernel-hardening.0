Return-Path: <kernel-hardening-return-21656-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BCE1DC76196
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Apr 2023 13:48:45 +0000 (UTC)
Received: (qmail 17836 invoked by uid 550); 10 Apr 2023 13:48:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11532 invoked from network); 10 Apr 2023 13:36:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tycho.pizza; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1681133780; x=1681220180; bh=Hc
	/zM6us12owjQAwpTXjH6fFrHxn+l06I2QCZ7puQjY=; b=ih5xW5HVZfx0inArLx
	gJQkJ13yTugobR+WROEywTumHayolrlDRYJKjropWd3y0tLePPVN7V3f3fX+lSal
	NnIdAjYw0Zg/Ggl6wewFyBgw6eUjRVs0ZvbJc8n68Pga2vkFGrW8HJWer0nYonMc
	/HwgYKt+uODdl1mkGyCxb/Fk8SvETH/EoN8VIhwQhwRHmLr3ZTpvYpARNIOUCdWQ
	F6qi0w3sY6Gl+gCzRpMpymNtR2h+8pDwzGNyhLN06BRnd3eN3FOf3+THuk4JRyMk
	VmP/COMlDl7e3SHa+6FWq+bt7O5SCdZLuOiRtdvNQDJQQpqlYtjQ8NPY6eaxgH+N
	3vGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1681133780; x=1681220180; bh=Hc/zM6us12owj
	QAwpTXjH6fFrHxn+l06I2QCZ7puQjY=; b=VY3fCXC65WhFf5bteDH8gYKFF1ayu
	NGWJja8KgJW3dImeDFBrR7E7m5p95VnDNHXCoiU+6R+Tp5H3cWPKL105TkwoF1CY
	1NaGrZB0VcDk036R9aYkysxITDncwWV9IQrVjLUo4G1JcXOYxnTpUX/onfXIC7bV
	9EKqk8nErZhIkplSwqYBdW1eCeYGbDljSlXfideJglsK+rtegZyi2UImKM9nTP1v
	is92FYJxT6xg/JkUWv8746i7bSqrOD56ZzPaPPPtWRMN81v4HlWzMlgedeBnnK9d
	VWrDkXToaywBdyx6KbLVYwW4kkyh7XSrKgimrbLjnGFm9ARJZkED1bj3A==
X-ME-Sender: <xms:1BA0ZNa51HxaUNXasLhbIvo-R3FBAzbJBXStorJvUVRjultDkVrntQ>
    <xme:1BA0ZEaAx3IDtWzbc0-YVyEEetvpmVEjHUjijBZDS1nizmhafiimYv8IPrTrWDmM0
    -qXCzT5_F4mWfqBXvE>
X-ME-Received: <xmr:1BA0ZP_ZGAjG8osL1hk2sraMVAFpVfKYOeOBUGgk_w1asrcVFYy-ZgmYtrLwrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekvddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepvfihtghh
    ohcutehnuggvrhhsvghnuceothihtghhohesthihtghhohdrphhiiiiirgeqnecuggftrf
    grthhtvghrnhepueettdetgfejfeffheffffekjeeuveeifeduleegjedutdefffetkeel
    hfelleetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epthihtghhohesthihtghhohdrphhiiiiirg
X-ME-Proxy: <xmx:1BA0ZLpXZyQCW5q4spEkOQYz6jcBGa3Xz0i8cKDgFdLO6qgXedFXmQ>
    <xmx:1BA0ZIo6jcA_hf407eeluHwset_GZlOq4yIhVavNDNU-YsYHCBGdMQ>
    <xmx:1BA0ZBSF2ALMnkv-giKnNhNVyNW0Go67hgCVldClyfKWYmiNcG3AAQ>
    <xmx:1BA0ZDX5HGZXK4eSuEzBf2jjs5ct8928lPxS4WAkpcD_SwISI3fi5w>
Feedback-ID: i21f147d5:Fastmail
Date: Mon, 10 Apr 2023 07:36:16 -0600
From: Tycho Andersen <tycho@tycho.pizza>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-modules <linux-modules@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Per-process flag set via prctl() to deny module loading?
Message-ID: <ZDQQ0B35NcYwQMyy@tycho.pizza>
References: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>

On Mon, Apr 10, 2023 at 01:06:00PM +0300, Topi Miettinen wrote:
> I'd propose to add a per-process flag to irrevocably deny any loading of
> kernel modules for the process and its children. The flag could be set (but
> not unset) via prctl() and for unprivileged processes, only when
> NoNewPrivileges is also set. This would be similar to CAP_SYS_MODULE, but
> unlike capabilities, there would be no issues with namespaces since the flag
> isn't namespaced.
> 
> The implementation should be very simple.
> 
> Preferably the flag, when configured, would be set by systemd, Firejail and
> maybe also container managers. The expectation would be that the permission
> to load modules would be retained only by udev and where SUID needs to be
> allowed (NoNewPrivileges unset).

You can do something like this today via STATIC_USERMODEHELPER without
the need for kernel patches. It is a bit heavyweight for a
general-purpose system though.

Tycho
