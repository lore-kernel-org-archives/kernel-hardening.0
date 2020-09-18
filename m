Return-Path: <SRS0=Abd6=C3=lists.openwall.com=kernel-hardening-return-19914-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352F9C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 14:52:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0700121973
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 14:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MvyM9dGS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0700121973
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19914-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8124 invoked by uid 550); 18 Sep 2020 14:51:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8104 invoked from network); 18 Sep 2020 14:51:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1600440654;
	bh=X9r1LJ5IHB4tO+eevCHgqRIcUhzs90X3pMd15oLbV50=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MvyM9dGSaE2Qu4OxCRARDpeLQCEXLTiK9oWdL7+oNHDfKrbRxI241Bl8y7JwT9yFh
	 2G8/6yithT+HbJ45GkJq9W0y+bIf3n+oy6tA0WcW4ggnI8gc3/0eQE/D1GRsRlIEk9
	 O5aCL87AGwcFomuc8PuPDS9NabEghLaahZFaQCCk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 18 Sep 2020 16:50:28 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>, Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the
 fbfam feature
Message-ID: <20200918145028.GA3229@ubuntu>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-2-keescook@chromium.org>
 <202009101615.8566BA3967@keescook>
 <20200917175146.GB3637@ubuntu>
 <202009171504.841FA53@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009171504.841FA53@keescook>
X-Provags-ID: V03:K1:gY8Y4R4sUuHKWJ2jglvTEjE03vqvwuBSnyOAPZP94GoGFbF5pda
 HLgTCJKuuFDOqcy9VoPpcxtTv/1G/BitFmn4E12fNb5xqU8cOZblAYVzc0yFrmvbmNT2EwM
 AruRuILQu31D7wG/0dIZEZEHIk/fKkgBanEErZE8OmLX7eH8Ih3tny2TK/upzt4mDcFzjNM
 FK4DlIEJYAvs5m4Fe8vEA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lV5Pm0nCUho=:97X2iu6Z5hsHdOIz7eNxRD
 czB3AqEbHZm4J9lfbEzGO7ZDawxEem1Btuh+QH/EkSsFrPHMofUyHCuSd0oQPIK5Rd/UU+4m5
 3IjGlIfN34mU2ze9v0O7u6RdubiIcKR12h0eHc5mCerXdq/DrvV0wbpcdQUvupdAnyyOVe3Q2
 3kzhI4E99pq9omIYKWLirT98twXmVJJNwJ+IPcAU7FMXIEqni0T5E6ykoYaeWjuw+u/QTRzlO
 UErBPu0fDPw3eKGRDaWDI1pbOxc/Cdpc0N/g3Kp8ECIxIXKoznH6SKA3FL3ounyHvGwuERBEp
 PZYDrlC0f2T3m1miVJJvtmt3ZIoORR3sg/QKMety6iNBtj2CnOZ3kq1KjcLVoFBp5glSA7s6U
 4REjHHWgmb06wI1qvS+OgNIGQe4m/F/jry/xs4Pi92oroC0z77j4hoxu87FfaFAZ5hIiTP1q0
 3LAEoVe1gunEJtoRGf7SjiyNXv+Oba+/dPVDhLobYAV4VO9fLfUTQi2SRwAy3jL1RT2kqjbK6
 SNWeb2moNbXraNIpImIlij0OlQn6Cx4GC/w7z1/dz+bSJ1AwFtUOUd0AlsgKVlpXAayf2qbOl
 Wx2ZZR+4EI/DezRYXX4xtYpIJtHKHFMwhk7ZvrHp0W3+iOK5FwSeSMUSax7kKvJXFhtjLOvXM
 g32RUwQO7ibXHMNhkJbgURguq+HnQ15jRQmZnTboX9dkBBWPPOmRvTlll7L1DxdvQDRmHH8xY
 cEUiP/5f6drXSq1YJEaV9H+efh69NmJNwlH6S0i55acQO9cZpf88sC/P+8zT0M49p0CW5Ynqo
 D3fAvq+zvdwWLwO/Y7EQ42bfQIspwjpcjbuWdc22nVzVglunmsk18OHPFgwwadfW5bNauH/p9
 og8fbMR7GRkUqkhKJoZFEaaSODRBg/4+wtRQFDI0AOAtHWv7LiQ5A5guxYO38594xfwvf8GGN
 ebcm0N0HNpmISbIdGmXFOpWvbwNSZ4SGhGI0Rp7rAHGj6TIrlXbP2Rr1jnae5j8iZ0GToYInO
 +MSyqE5rHdUMc/Vq1HNu7rk7kKhGx49Srz26I4gANX41pxK9PDwVPEc52iRs6ENy4ITjiIoQw
 HkeVABLJGLHwu1dfoPBVR71mVVh/YevtUXolIfKaVtDb6vcWFkzas6VzF9oMooji5oXA6rOGM
 aUFUNaIPjc0g4zi2q6KXL/8j5iDO8MYgxZildGCfJq/lBfqc4t+1d6zfnSjTQHJI20kawaIig
 38KlcxAFATvyLsE0IJa/RPoTLzPoRbitcjehl9g==
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2020 at 03:05:18PM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2020 at 08:40:06PM +0200, John Wood wrote:
> > > To jump on the bikeshed: how about just calling this
> > > FORK_BRUTE_FORCE_DETECTION or FORK_BRUTE, and the directory could be
> > > "brute", etc. "fbfam" doesn't tell anyone anything.
> >
> > Understood. But how about use the fbfam abbreviation in the code? Like=
 as
> > function name prefix, struct name prefix, ... It would be better to us=
e a
> > more descriptive name in this scenario? It is not clear to me.
>
> I don't feel too strongly, but I think having the CONFIG roughly match
> the directory name, roughly match the function prefixes should be best.
> Maybe call the directory and function prefix "brute"?

Thanks for the clarification.

> --
> Kees Cook

Regards,
John Wood
