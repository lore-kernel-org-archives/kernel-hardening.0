Return-Path: <kernel-hardening-return-21688-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E2C33C83F11
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Aug 2023 18:07:05 +0000 (UTC)
Received: (qmail 11988 invoked by uid 550); 28 Aug 2023 18:06:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11363 invoked from network); 28 Aug 2023 16:43:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693240981; x=1693845781;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rX1Y+NFd/Cth5mucuFnYvnydfdg+SNBFi/Pdp7f9Sc8=;
        b=Z+034cpS+xFtTJmqfYXgkAONZiWt2TJgEKthJMQsiJZPyBtAiJWHpgZy66UyLqWL8k
         oYGb5MDbGWX3OuSLs31gl11JG3GrknMHlZQfgvGMJZ1lrTqyOpArUzRQSO6zVAXA1r16
         ZTX/7+oEc1r1xQ5Fh7rqxoG1B88Zm08YTfzEkrgPhH7FAkQ3Uw+2WV0Ij29STyiJodeL
         5fhxtfxKbLqs7kO70jVeZCnWGqTu2NBzNxpkFAo6BH6Z8TlbwRndF3uYZd7HGr/GJKzt
         FUhNT3QIWXzwQDyY+ub2UcD2vX/2uAa9ZkOS2QDef4+SOSctNL2vY5l3gnJXSvRbFHP4
         EVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693240981; x=1693845781;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rX1Y+NFd/Cth5mucuFnYvnydfdg+SNBFi/Pdp7f9Sc8=;
        b=YXd8s4CJagVdEFjYuJ5JSnpOZwcve2gsrsnomclzTpdajR+tOZBhYWiwZvPyNDe3+i
         wNGBSLrB6TKkQzsAVn4e9Kson/ku8VokxfcdhFxbq1y2nXdNPGBf7NyNleSQCo0WPsZn
         VPZmIm5wcsqryg1ON3zWMqKq7G5EyvFenhc+JNz9myEoOAjXmZfMWbSSTn9ri3wBLYWX
         wDwArWtgSr4a6DgT7PaJhPs5JjxNvCd9yT+20yV9SrQixgMqVlOcBvK6G4y97BZTK8Z+
         qweCeDVnbYQWwW0vBfblNF15wvCnr7A6CZJ7pYqOecJIXg+wWLj42nTzgD8uJEYfnNtA
         YxuQ==
X-Gm-Message-State: AOJu0Yxk1awMksEpFu41ARmfgAMXb1CK7AXcHEQo53nTUEsbgOmXeHIM
	24NRkfrFEtBxv8CgJt5sr3MjoNFrr5M=
X-Google-Smtp-Source: AGHT+IE683oBXLeb6rbivDCunY8LUaJbbVorgEMJ4dLDsTFZw0maDTPBCdpul4GXUf+0OO+All6pInFQXTY=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:d62e:36f4:33c6:e661])
 (user=gnoack job=sendgmr) by 2002:a81:af16:0:b0:57a:793:7fb0 with SMTP id
 n22-20020a81af16000000b0057a07937fb0mr830868ywh.3.1693240981054; Mon, 28 Aug
 2023 09:43:01 -0700 (PDT)
Date: Mon, 28 Aug 2023 18:42:58 +0200
In-Reply-To: <2023082836-masses-gyration-0e7e@gregkh>
Message-Id: <ZOzOkt8/Icws1+Vn@google.com>
Mime-Version: 1.0
References: <20230828122109.3529221-1-gnoack@google.com> <20230828122109.3529221-2-gnoack@google.com>
 <2023082836-masses-gyration-0e7e@gregkh>
Subject: Re: [PATCH v2 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste subcommands
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Hanno =?iso-8859-1?Q?B=F6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, 
	"=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 28, 2023 at 04:48:28PM +0200, Greg KH wrote:
> On Mon, Aug 28, 2023 at 02:21:09PM +0200, G=C3=BCnther Noack wrote:
> > Signed-off-by: Hanno B=C3=B6ck <hanno@hboeck.de>
> > Tested-by: G=C3=BCnther Noack <gnoack@google.com>
>=20
> When you pass on a patch like this, you too need to sign off on it as
> per the instructions in the DCO.  I'm pretty sure the Google open source
> training also says that, but maybe not.  If not, it should :)

Ah sorry -- fixed and re-sent.

=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
