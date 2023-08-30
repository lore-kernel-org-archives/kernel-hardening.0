Return-Path: <kernel-hardening-return-21693-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 11468C6FA8F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Aug 2023 11:08:27 +0000 (UTC)
Received: (qmail 1862 invoked by uid 550); 30 Aug 2023 11:08:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17769 invoked from network); 30 Aug 2023 00:36:57 -0000
Date: Wed, 30 Aug 2023 02:36:44 +0200
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
Message-ID: <20230830003644.myhabo5mlvljbkkb@begin>
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
 <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZO3r42zKRrypg/eM@google.com>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)

Günther Noack, le mar. 29 août 2023 15:00:19 +0200, a ecrit:
>  * gpm:
>      I've verified that this works with the patch.
>      (To my surprise, Debian does not index this project's code.)

? it does. But gpm does not use TIOCL_* constants unfortunately...

Samuel
