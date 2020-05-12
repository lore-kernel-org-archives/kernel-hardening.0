Return-Path: <SRS0=jcsM=62=lists.openwall.com=kernel-hardening-return-18774-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B907C2D0FA
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 22:03:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC7CB20784
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 22:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYcW5rGW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC7CB20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18774-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9796 invoked by uid 550); 12 May 2020 22:03:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9776 invoked from network); 12 May 2020 22:03:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1589321013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ns5UOQMLizpSxZdFpRK9TbCkGBwHVENlcHczF4G1fL8=;
	b=EYcW5rGWWIgsmSaDRNG+L3S+WST2fWSrvESu4rVnHvda62r7oXqRR86GjrAeSuu5ZFBfzO
	VU4hmjbwaWDsMJrDy2yuwCBGCEoN0lNQuAfbe98PVaLO3ZrcBv+UwPj+DhthhupcJzH5Ba
	OAwPccVs2Emgm5VjKxdCIiqaonyA0dQ=
X-MC-Unique: 0MUo9GkKPLKCnl2yk28XwQ-1
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHmME9q-TxHo5o63rxHzKwV_kWV9u+MoxBQM5Yz3hODGCj7RhQ@mail.gmail.com>
References: <CAHmME9q-TxHo5o63rxHzKwV_kWV9u+MoxBQM5Yz3hODGCj7RhQ@mail.gmail.com> <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com> <20200511215101.302530-1-Jason@zx2c4.com> <2620780.1589289425@warthog.procyon.org.uk>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
    LKML <linux-kernel@vger.kernel.org>,
    Andy Lutomirski <luto@kernel.org>,
    Greg KH <gregkh@linuxfoundation.org>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    kernel-hardening@lists.openwall.com,
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v3] security/keys: rewrite big_key crypto to use library interface
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2858488.1589321003.1@warthog.procyon.org.uk>
Date: Tue, 12 May 2020 23:03:23 +0100
Message-ID: <2858489.1589321003@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> So long as that ->update function:
> 1. Deletes the old on-disk data.
> 2. Deletes the old key from the inode.
> 3. Generates a new key using get_random_bytes.
> 4. Stores that new key in the inode.
> 5. Encrypts the updated data afresh with the new key.
> 6. Puts the updated data onto disk,
> 
> then this is fine with me, and feel free to have my Acked-by if you
> want. But if it doesn't do that -- i.e. if it tries to reuse the old
> key or similar -- then this isn't fine. But it sounds like from what
> you've described that things are actually fine, in which case, I guess
> it makes sense to apply your patch ontop of mine and commit these.

Yep.  It calls big_key_destroy(), which clears away the old stuff just as when
a key is being destroyed, then generic_key_instantiate() just as when a key is
being set up.

The key ID and the key metadata (ownership, perms, expiry) are maintained, but
the payload is just completely replaced.

David

