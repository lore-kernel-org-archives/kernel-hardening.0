Return-Path: <SRS0=i6c5=62=lists.openwall.com=kernel-hardening-return-18769-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BF1C2D0F8
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 21:39:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94D5320740
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 21:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MvD3LboV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94D5320740
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18769-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26131 invoked by uid 550); 12 May 2020 21:39:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26111 invoked from network); 12 May 2020 21:39:02 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=QHZdxdAznvbCsAtmKjiWvIM9Rkw=; b=MvD3Lb
	oVsAoirYLJSrJWid+5RlALnx2IRewi5D0XBFtensY47q3F11/1CtwFB5Eegu/rI1
	Pid6Wx2EvUYjZPfmZGjw9K8P6wYoy6QkCFrPmSyueGYQT0ehJ+ObAbPUH/MO80YR
	lgG2lkNpdMeTNMDZJrtZbEKLjK/ohUsVlltq0XSXirzYqVDik4HdhkLxhPByleUi
	nIVklcGJio1YXP5DG4ogblcqJZJ0R7MUkdxyQhzMhK8vZhyd40aaYk8jf5X45I5k
	3BNLQAauYx/2QdATKBVB+tr2WW5c6Ps2riW9WvCxzbdw/kouf6sYczcIznGhlmMf
	v+IXNN0GTccJmRDQ==
X-Gm-Message-State: AGi0PuZQYjKJvWqaJKN3DxGt6SVL6wGwT6r/xbSsQdDP6bTJ5rHBa3zH
	1VuHyx6CuO+32rta6t5bky2gKGDC2fXklwyBnlE=
X-Google-Smtp-Source: APiQypJzMvF0pm2HCVQ5PwdpsSCqC6FjWIGTFESdbJ/delouG0Mi5pZJuKDQJHB5ZYDpPpJ7fdbGT//MYh2mBmx/jhU=
X-Received: by 2002:a92:8752:: with SMTP id d18mr6109118ilm.224.1589319528551;
 Tue, 12 May 2020 14:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com>
 <20200511215101.302530-1-Jason@zx2c4.com> <2620780.1589289425@warthog.procyon.org.uk>
In-Reply-To: <2620780.1589289425@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 12 May 2020 15:38:37 -0600
X-Gmail-Original-Message-ID: <CAHmME9q-TxHo5o63rxHzKwV_kWV9u+MoxBQM5Yz3hODGCj7RhQ@mail.gmail.com>
Message-ID: <CAHmME9q-TxHo5o63rxHzKwV_kWV9u+MoxBQM5Yz3hODGCj7RhQ@mail.gmail.com>
Subject: Re: [PATCH v3] security/keys: rewrite big_key crypto to use library interface
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi David,

So long as that ->update function:
1. Deletes the old on-disk data.
2. Deletes the old key from the inode.
3. Generates a new key using get_random_bytes.
4. Stores that new key in the inode.
5. Encrypts the updated data afresh with the new key.
6. Puts the updated data onto disk,

then this is fine with me, and feel free to have my Acked-by if you
want. But if it doesn't do that -- i.e. if it tries to reuse the old
key or similar -- then this isn't fine. But it sounds like from what
you've described that things are actually fine, in which case, I guess
it makes sense to apply your patch ontop of mine and commit these.

Jason
