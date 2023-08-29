Return-Path: <kernel-hardening-return-21692-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 93DE9C71153
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Aug 2023 13:10:51 +0000 (UTC)
Received: (qmail 15567 invoked by uid 550); 29 Aug 2023 13:10:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7355 invoked from network); 29 Aug 2023 13:00:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693314022; x=1693918822;
        h=content-transfer-encoding:to:from:subject:references:mime-version
         :message-id:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EtpptAZRYLNvIpEn9OUVTzG5fKukD8GhKA/2HzNRf94=;
        b=TLWHh1+axXIAFYk2i2gQ3hsgLFdU0lX+bfKUFCxKgFjGup35y0fkJaqn903znroPOP
         aAWYbEk43NrgjVcXBBSdrhPpYFSEqHw7xWYEA9lNoWzhfqeGf28WPGP0DNleTimw7Dwo
         ZaXw7A2TcVIjfw091W75xJQU8+Y6XRgd2BfikeBOxZlNGEznlEYe2NbzMpEEurpafEvH
         oYyj48AVrASGUleqU8LpaEMz0THpRbH2CH5V38OAeDcViOdk61CvPVdGg6+tgKTKZA8K
         hCIu9Hd1h09zy/gdwsY6LE6hHCbtao1wxTQlp8RN9WgRHL7r4NkQSEzqEhWQxIWd2VEK
         5HwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693314022; x=1693918822;
        h=content-transfer-encoding:to:from:subject:references:mime-version
         :message-id:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EtpptAZRYLNvIpEn9OUVTzG5fKukD8GhKA/2HzNRf94=;
        b=JhGs54UfOZMcolI7S459EiscUAYXEG/tlof4rnDA7Fb2b07a9CJZtTNJxtlJDFJdSi
         Z6k0t3/Q9j5NfTDtZj7JMpwk5yt6Me3V4qRdV4jgWRIjE2RPxAu2AwaajF3eEqyAp/IA
         n55eHHvCIrWnPJYhrHzPxdsVdanuSjpi9OemcjCJE5FtQLlcFpsI2xh/8VZyqI1Dugkk
         C48akv1svH8kYCaGUpHam9+zAeKy1nb3VzqqRtZwKAZjwGOsqU9lJa4dh3AAJ7XHX45D
         PxM7fLTLLUKUcjsDcBYnydylRyX87vgft8a/2BeEiEWJUMN9XUTaO601XrfPXrCiR4L0
         uXBQ==
X-Gm-Message-State: AOJu0YzhK3zIQaTwafejYYv2xJxlN+sCE+YSVLK6JeZ3zI1OM6zpCwMO
	dl9F2e+6TnHz6DbPK6vKOdlJWBzObg4=
X-Google-Smtp-Source: AGHT+IG9F4AFLoiZ3dnx2ei+w2llEOr1ojoVIITQWDmRK8UluCvhO0zf7rvS0dw1XPgIVrG/8A6LIhNBC7c=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:3a85:25f:1fd0:2090])
 (user=gnoack job=sendgmr) by 2002:a50:cdd4:0:b0:525:573c:6af5 with SMTP id
 h20-20020a50cdd4000000b00525573c6af5mr47112edj.4.1693314022268; Tue, 29 Aug
 2023 06:00:22 -0700 (PDT)
Date: Tue, 29 Aug 2023 15:00:19 +0200
In-Reply-To: <20230828164521.tpvubdufa62g7zwc@begin>
Message-Id: <ZO3r42zKRrypg/eM@google.com>
Mime-Version: 1.0
References: <20230828164117.3608812-1-gnoack@google.com> <20230828164521.tpvubdufa62g7zwc@begin>
Subject: Re: [PATCH v3 0/1] Restrict access to TIOCLINUX
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, Greg KH <gregkh@linuxfoundation.org>, 
	"Hanno =?iso-8859-1?Q?B=F6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	David Laight <David.Laight@aculab.com>, Simon Brand <simon.brand@postadigitale.de>, 
	Dave Mielke <Dave@mielke.cc>, "=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello Samuel!

On Mon, Aug 28, 2023 at 06:45:21PM +0200, Samuel Thibault wrote:
> G=C3=BCnther Noack, le lun. 28 ao=C3=BBt 2023 18:41:16 +0200, a ecrit:
> BRLTTY also uses it. It is also admin, so your change is fine :)
>=20
> FI, https://codesearch.debian.net/ is a very convenient tool to check
> what FOSS might be using something.

Thanks, that is an excellent pointer!

Let me update the list of known usages then: The TIOCL_SETSEL, TIOCL_PASTES=
EL
and TIOCL_SELLOADLUT mentions found on codesearch.debian.net are:

(1) Actual invocations:

 * consolation:
     "consolation" is a gpm clone, which also runs as root.
     (I have not had the chance to test this one yet.)
 * BRLTTY:
     Uses TIOCL_SETSEL as a means to highlight portions of the screen.
     The TIOCSTI patch made BRLTTY work by requiring CAP_SYS_ADMIN,
     so we know that BRLTTY has that capability (it runs as root and
     does not drop it).

(2) Some irrelevant matches:

 * snapd: has a unit test mentioning it, to test their seccomp filters
 * libexplain: mentions it, but does not call it (it's a library for
   human-readably decoding system calls)
 * manpages: documentation


*Outside* of codesearch.debian.org:

 * gpm:
     I've verified that this works with the patch.
     (To my surprise, Debian does not index this project's code.)

FWIW, I also briefly looked into "jamd" (https://jamd.sourceforge.net/), wh=
ich
was mentioned as similar in the manpage for "consolation", but that softwar=
e
does not use any ioctls at all.

So overall, it still seems like nothing should break. =F0=9F=91=8D

=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
