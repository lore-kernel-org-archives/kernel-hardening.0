Return-Path: <SRS0=rg6H=63=lists.openwall.com=kernel-hardening-return-18776-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E7AC2D0F6
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 May 2020 02:33:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A1A8A206D3
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 May 2020 02:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="1m1PFJ2B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1A8A206D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18776-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3710 invoked by uid 550); 13 May 2020 02:33:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3690 invoked from network); 13 May 2020 02:33:36 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=9cAMlLbYwy7YxFnVgonuDYVCQ7Y=; b=1m1PFJ
	2B+8CtLPfFKydV2Eqa4Iou4wbcYCYArA8utEK56pKUtvPY8GyQDYxSflLjzyeySc
	XVCoTB3ryeoFAOK1PJgt/GKg8T6VWi/SKiUUg0VCvhPTtgNLyLAj9J8arRB1Q/jK
	XVs4nbCnzQnmzE5bflXX58+mr5wfZOcesWXaNWPoL9j+KdeFfh/F0C2G6ZhRc+At
	NaXpXlxgGtS77ZgZEedUSyOTwbZaLGXqZ3VnL82nV9T3lZFyoysQEatZ3+gdT208
	I65k13q3L3wDSLzTiAUOW+4kOCBLaqMleGTlAEQ3NzD3v9BDrzB3FdZaoywd+vOr
	kNo19N145XvIZ5pg==
X-Gm-Message-State: AGi0Pub80Dh48tPdvCsoGr4dKjXaX53GWCs5sk38GiO3TfhKANWWVtEx
	6i+pm20n8oabB7aq43zrwvJ5jtKCCMs6sGrW/tM=
X-Google-Smtp-Source: APiQypJgh8pw02tJhFhZVYZHUeMe4CkR7vQq3ZoiDzB43+wYjuX9PsMkHQ584E/CvIIJSREZQMxGHmOWxbe4h+OTD5M=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr25252998ilg.231.1589337202376;
 Tue, 12 May 2020 19:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com>
 <20200511215101.302530-1-Jason@zx2c4.com> <2620780.1589289425@warthog.procyon.org.uk>
 <CAHmME9q-TxHo5o63rxHzKwV_kWV9u+MoxBQM5Yz3hODGCj7RhQ@mail.gmail.com> <2858489.1589321003@warthog.procyon.org.uk>
In-Reply-To: <2858489.1589321003@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 12 May 2020 20:33:11 -0600
X-Gmail-Original-Message-ID: <CAHmME9r4Pag4ML-GVaKHFTZ_T_unhWg1LxVuEk6wKp006ZAFXg@mail.gmail.com>
Message-ID: <CAHmME9r4Pag4ML-GVaKHFTZ_T_unhWg1LxVuEk6wKp006ZAFXg@mail.gmail.com>
Subject: Re: [PATCH v3] security/keys: rewrite big_key crypto to use library interface
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 12, 2020 at 4:03 PM David Howells <dhowells@redhat.com> wrote:
>
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > So long as that ->update function:
> > 1. Deletes the old on-disk data.
> > 2. Deletes the old key from the inode.
> > 3. Generates a new key using get_random_bytes.
> > 4. Stores that new key in the inode.
> > 5. Encrypts the updated data afresh with the new key.
> > 6. Puts the updated data onto disk,
> >
> > then this is fine with me, and feel free to have my Acked-by if you
> > want. But if it doesn't do that -- i.e. if it tries to reuse the old
> > key or similar -- then this isn't fine. But it sounds like from what
> > you've described that things are actually fine, in which case, I guess
> > it makes sense to apply your patch ontop of mine and commit these.
>
> Yep.  It calls big_key_destroy(), which clears away the old stuff just as when
> a key is being destroyed, then generic_key_instantiate() just as when a key is
> being set up.
>
> The key ID and the key metadata (ownership, perms, expiry) are maintained, but
> the payload is just completely replaced.

Okay, in that case, take my:

    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

And then perhaps you can take both my patch and your addendum into keys-next.

Jason
