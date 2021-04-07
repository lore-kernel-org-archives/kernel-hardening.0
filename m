Return-Path: <SRS0=rDKi=JE=lists.openwall.com=kernel-hardening-return-21173-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65B6C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 20:39:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C11FA611EE
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 20:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C11FA611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vt.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21173-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1544 invoked by uid 550); 7 Apr 2021 20:39:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1509 invoked from network); 7 Apr 2021 20:39:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version
         :content-transfer-encoding:date:message-id;
        bh=C3kqp5Td/9JCZerOI7VqLOw+NwL5J1xa69D5ZPSTZbg=;
        b=yw3wK1mZftSU4NVHBVqRT3q3dLhbck9rPdw5wHei6RDZUJJ3t7Sb7CEcrUwGH5J8zn
         WliQzJsxFGSucvQxa+sYF8OrbZvpxx6H3t3lBKappsyrFcO0vq3m2zCUi0T4V7utu6JZ
         BOAqzLMoOw60FMx6qiN6bcmizny/gtmwsTcFcJglRtu1VPl6ckJral06h73F4hZpqQpg
         Xu8rn0Dezqbq9XLZl06ZCCXVs+Ze7MFNLcm2P/M7E/db9gIZlSjt6kzMYDa+hwXfkqiB
         UjkCstZ2w8P2SOeEkA5ukL10H827uVjB0mOjV+3xBcvyB4AVNMx1u9mxQDIS5Bwl07sn
         YVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=C3kqp5Td/9JCZerOI7VqLOw+NwL5J1xa69D5ZPSTZbg=;
        b=RUC4EbPfQkF6Li+rJiYQr+XMA0POX7G4uy5sMLJhBq1MXvSTcW0jOE8wje6461ckLb
         VJLNZIXdzWgNTN4M41bjrnpfSW4xn0q1LJ0nR4I5gsRg9brcRrpR2dtAfSdePxUSY8yD
         nocT+B1nhGhWf+OJ25+dhCqk+27m5j1LArayn+GqvHUDWnRODWOC/zvfPt/mFEC5m6A9
         +BzPaMNEf6gesmjnjlNysFfM7a2No0Q8VTldhzeLDs/dHF8m3SMlldEunuNJ+5e2LCAu
         3jVxgCx3Pi41NzW/ohGyXJShbt229gbRL3H0yp6MytO5Y7gbh7tnZIBZNk3BY8wmt55S
         lpdA==
X-Gm-Message-State: AOAM532fP9O9iN0fAtU8DI8GFru6DAYWr99tLRzu6SgD0g+1DLR2mXNo
	aXGORhOfre9eZfZCmXd6oZbc6g==
X-Google-Smtp-Source: ABdhPJzhrEwcC145g7278+sNzShCM65TW9zp1mWSdt2Cgl6ntkwzNXEFRfoXViZWxHcYphLTUehHUA==
X-Received: by 2002:ad4:554e:: with SMTP id v14mr5389211qvy.49.1617827928505;
        Wed, 07 Apr 2021 13:38:48 -0700 (PDT)
Sender: Valdis Kletnieks <valdis@vt.edu>
From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To: John Wood <john.wood@gmx.com>
Cc: kernelnewbies@kernelnewbies.org, Andi Kleen <ak@linux.intel.com>,
    Kees Cook <keescook@chromium.org>,
    kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
In-Reply-To: <20210407175151.GA3301@ubuntu>
References: <20210330173459.GA3163@ubuntu> <79804.1617129638@turing-police> <20210402124932.GA3012@ubuntu> <106842.1617421818@turing-police> <20210403070226.GA3002@ubuntu> <145687.1617485641@turing-police> <20210404094837.GA3263@ubuntu> <193167.1617570625@turing-police> <20210405073147.GA3053@ubuntu> <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1617827926_108837P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Apr 2021 16:38:46 -0400
Message-ID: <184666.1617827926@turing-police>

--==_Exmh_1617827926_108837P
Content-Type: text/plain; charset=us-ascii

On Wed, 07 Apr 2021 19:51:51 +0200, John Wood said:

> When brute detects a brute force attack through the fork system call
> (killing p3) it will mark the binary file executed by p3 as "not allowed".
> From now on, any execve that try to run this binary will fail. This way it
> is not necessary to notify nothing to userspace and also we avoid an exec
> brute force attack due to the respawn of processes [2] by a supervisor
> (abused or not by a bad guy).

You're not thinking evil enough. :)

I didn't even finish the line that starts "From now on.." before I started
wondering "How can I abuse this to hang or crash a system?"  And it only took
me a few seconds to come up with an attack. All you need to do is find a way to
sigsegv /bin/bash... and that's easy to do by forking, excecve /bin/bash, and
then use ptrace() to screw the child process's stack and cause a sigsegv.

Say goodnight Gracie...

--==_Exmh_1617827926_108837P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBYG4YVgdmEQWDXROgAQKAIA/+JQc2HVjebFAqdhBguHXlMpdRbqE/TK88
QcsBwIUIzRafTVrQeQ0+9SKo7X419zxUkIziKKSdzWqoHQ5XltS3eyzR8IF/O/D1
HrDTA9d8SNGRERSQC9wSfjwBGK3Ru1kZ/2Frsr+HCf7z0h7Jh+2xp2mDc8cJNQWn
Z0wJPF3EjC/zqZIuaNNFTTupSO++FpIQEAgIWOTlq2TGjuYcnaZ+UJpwhoiLK4wY
WAtF8ke7xwTVWYdAfjhJAYVzeFHwaTogppZwShPZuBQIEua8Qv3WvjVtE891RM9E
ahhFIDd0jVJy0lYp1FQibstKCYYYgSwV0R4EanWUPx5X3GSTyivIvgNBT4bqjaqd
CMLR20uh/lr/xxXKr8fPr93i6thkrunWQO+MOVKdv6sW8BLTzUW/eK+69seEo/Di
+78L4XVDYK3wX2ZCUSHbfytznoYRUXBTzPmcGn2NcX1eB93ZSB4tMPmK2dX2XEO9
58gm7dybXESOlHaOJn5MpPrHzaRyUJIhDerMEqsgITDpMcxdgfV8/SBtwlS4C+xP
J1zavftL5IFdk+/MNDjcZpyhkVgMnbGXgTYiwWmW1PM485OKux3f69OK28htgA7x
xIZpc3ipOPKKDEUeD9bwqk2Yh7G0AQUII8ybOsrMim3P/6sQBMa07eqj6maDyOWQ
ywYJVv+FHTo=
=ktc2
-----END PGP SIGNATURE-----

--==_Exmh_1617827926_108837P--
