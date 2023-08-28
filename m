Return-Path: <kernel-hardening-return-21689-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 35CE9C83F11
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 18:07:17 +0000 (UTC)
Received: (qmail 12226 invoked by uid 550); 28 Aug 2023 18:06:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13555 invoked from network); 28 Aug 2023 16:45:36 -0000
Date: Mon, 28 Aug 2023 18:45:21 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: Re: [PATCH v3 0/1] Restrict access to TIOCLINUX
Message-ID: <20230828164521.tpvubdufa62g7zwc@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
References: <20230828164117.3608812-1-gnoack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230828164117.3608812-1-gnoack@google.com>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)

Günther Noack, le lun. 28 août 2023 18:41:16 +0200, a ecrit:
> The number of affected programs should be much lower than it was the case for
> TIOCSTI (as TIOCLINUX only applies to virtual terminals), and even in the
> TIOCLINUX case, only a handful of legitimate use cases were mentioned.  (BRLTTY,
> tcsh, Emacs, special versions of "mail").  I have high confidence that GPM is
> the only existing usage of that copy-and-paste feature.

BRLTTY also uses it. It is also admin, so your change is fine :)

FI, https://codesearch.debian.net/ is a very convenient tool to check
what FOSS might be using something.

Samuel
