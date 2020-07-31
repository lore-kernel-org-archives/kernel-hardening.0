Return-Path: <SRS0=kT4R=BK=lists.openwall.com=kernel-hardening-return-19505-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BBFC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jul 2020 12:50:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3F6F92087C
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jul 2020 12:50:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYONy1EG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F6F92087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19505-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29932 invoked by uid 550); 31 Jul 2020 12:49:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3863 invoked from network); 31 Jul 2020 09:20:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=8mD+nqB33TkoOoj/gJgWM5VeBC7j95G7SbgFkstL1+Y=;
        b=kYONy1EGZKl0txXMXdnNJT1Y23m2++O6HdGV8zLgsm4sCEMAk4SBmQNWhlxd1RyFjF
         mH9uaD7kMfSnJQuXDiqulF7cksFMlMFyQu1uhXZJKRRkx/rfeldFPCsO2st4PnmT/kDq
         GgQWPaMYzTpc2zdZcMeYUCGhg0EPuQUpoOWYoK/2aGEYM9vehvSOPrTkPc3veCvTt9+4
         vBmykpfMFEq9dDLUBzRBMzYkCzqkG+OST7U2uHzggevt/iPDVH0iMUQZFOaFL7U7aUQA
         EGMxdwknpaXiN9Z1bmHGl6cwvZpRnPncn/hh48VAwiif+7nAFYKUPceAD4e6TjEWS9uL
         A6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=8mD+nqB33TkoOoj/gJgWM5VeBC7j95G7SbgFkstL1+Y=;
        b=cpyJ1UFyahRX1rWKErgvAQUcpubCBJ0PjmkD0TYD5F3J5MqwNrhYBhvqX4rTk2udt9
         LiF60w8TqxAngI3XDtibxgON8GZY6LV8EGqrK4peAgDLRCKIBGtpKWgyKOXARX/tbt82
         zgQtRc1jIhAUB96cDk36KqFTf5S8eR8djxkNDoPmjudYN+4fH3+C1imIOnRuxNj4+umf
         ftM8G1uAp/dy91Ypoll8H4IiN7crahtXDJqU6neY9T6pfjGMhn+xgMIIlqTe5bAwUBnG
         1HfZ/umQMgzKNHXVAPZp8U9fBwDzldyvZqinf9CUWDrGabn6Y2N9qKUpkAMuGINQERDC
         cSjw==
X-Gm-Message-State: AOAM53048sZS4U1MZEvZjGFlcNn81DW8rOM8eJsO19j0XUwxJQ04smXA
	AOIjCI1Ty8avwsC+mtwjlr4WmVbgWrs=
X-Google-Smtp-Source: ABdhPJzX+r8g5hxwtM4cWf4LYMeGpaFl7y04AtV1EWXCDj7oMyC8Q9bisj8CbBCupPDW3m2AB12hbw==
X-Received: by 2002:a19:8607:: with SMTP id i7mr1555288lfd.208.1596187209458;
        Fri, 31 Jul 2020 02:20:09 -0700 (PDT)
Sender: Felipe Balbi <balbif@gmail.com>
From: Felipe Balbi <balbi@kernel.org>
To: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Allen Pais <allen.lkml@gmail.com>, Oscar Carter <oscar.carter@gmx.com>, Romain Perier <romain.perier@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kevin Curtis <kevin.curtis@farsite.co.uk>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Harald Freudenberger <freude@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jiri Slaby <jslaby@suse.com>, Jason Wessel <jason.wessel@windriver.com>, Daniel
 Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Mitchell Blank Jr <mitch@sfgoth.com>, Julian
 Wiedmann <jwi@linux.ibm.com>, Karsten Graul <kgraul@linux.ibm.com>, Ursula
 Braun <ubraun@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Christian Gromm <christian.gromm@microchip.com>, Nishka
 Dasgupta <nishkadg.linux@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, Stephen Boyd <swboyd@chromium.org>, "Matthew Wilcox \(Oracle\)" <willy@infradead.org>, Wambui Karuga <wambui.karugax@gmail.com>, Guenter
 Roeck <linux@roeck-us.net>, Chris Packham <chris.packham@alliedtelesis.co.nz>, Kyungtae Kim <kt0755@gmail.com>, Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Jonathan Corbet <corbet@lwn.net>, Peter
 Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, alsa-devel@alsa-project.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 1/3] usb: gadget: udc: Avoid tasklet passing a global
In-Reply-To: <20200716030847.1564131-2-keescook@chromium.org>
References: <20200716030847.1564131-1-keescook@chromium.org> <20200716030847.1564131-2-keescook@chromium.org>
Date: Fri, 31 Jul 2020 12:20:02 +0300
Message-ID: <87zh7gm471.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Kees Cook <keescook@chromium.org> writes:
> There's no reason for the tasklet callback to set an argument since it
> always uses a global. Instead, use the global directly, in preparation
> for converting the tasklet subsystem to modern callback conventions.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

looks okay to me.

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl8j4kIACgkQzL64meEa
mQZ6zQ//ZXtGFv/fRsm1+M9OI2t7qOY4ZsyygLSKzdncJp2pYVhKXNiMOjtYNxRV
Hv8GjhXRlsOn7pZZ+BqcYWDjvJM20owDzT0NS7oeLKFeIXB6QR5Y/viDETy3MkId
eq1gPhxbK2szcyYVUqC6/qaOuDVpPV4PKlLDPfXev8REL78mYBAgKb5a8kVuZnjo
Lcg64xhnc9YAc5gj+f2HnybldhmU606mRQt/RDQlK9uUymMsD7rZw0L6zfV5r7AY
0oWUzryBMvVMMZ3l0ZpdiSWqoRVgOplih5AHcH4SFZq/5Rv14F7ILAV3JNsIoGZ3
x7MwtAJuIBmBNr48PSDtLu5ntF8OpRLhwBvt6onOzbOyqpk6TnjfbmVHcorlWtfE
tSy2qOo9W6Smc6NsFLcaoYlZUVAiPr2R0Ogap0ISvFF6nBe1b3CEp9Hco79blWCy
1CiCwhq17U6q3tgrRRc34+zewtdAYw+Xze3TNBhQi3EOuCjNNXAoNl6v20/8LOsI
lijSWagZFc7o3LM9xsxWhFVrAWI5bXY+1CmPdwd4dHbaCXg2rcQ33MGP0Uum/bHu
DijJZ1LszhIf1RgXrOD/kmY/WmSh4Nh6nQkdssxXSabz0oN0wsuxMfgNqnkcnIj9
56pCsJHf2phFZyTaMDgzL17tcfor5xQQs27yAoGI1ygKelTGAjY=
=ua4k
-----END PGP SIGNATURE-----
--=-=-=--
