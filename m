Return-Path: <SRS0=/CK3=6Z=lists.openwall.com=kernel-hardening-return-18762-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBBEC54E4A
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 21:42:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB2DE206F5
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 21:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="0St7aj+n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB2DE206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18762-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17793 invoked by uid 550); 11 May 2020 21:41:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17768 invoked from network); 11 May 2020 21:41:52 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=j4FycMwidlQ6IKag2VUkMXIbW38=; b=0St7aj
	+n3YMOdGYwo1TV6LnPuyAJTAmhlInyZPK1XOh55yI3C6WEVnpAjb7OfaHIy6U+f3
	IcKXyoEgrS9OoitJQXonMh17/ofsWx4pXW13NS7qVSHLba3qIEFfQvFQsN2DUdmy
	iqaFyM9t5e+npaoOvQALxi7oYEiqzbUuQP+UsCUf4xDS0m7zOQzRFcfUnIwXtj0z
	dCBB4dYBFcX1ZUyEBP+elrsZbaf6sSllqKSiIpy/klRbb9Q30mmyd5/btNVBxD/1
	odQ/VScn1PXQn3qKvQeUpdoJr+HrIToc6onhmXqjiP81lczIno39FlLyrygGO/Z4
	NcInansAFZ+jh8RQ==
X-Gm-Message-State: AGi0PuZrrwTvVNFtiV6ZrQXjn7v74tO0zztio54Ap/Ueg1Uk3KpGxAhB
	HoR8uCKqb3qHndcA+loLyOy9q9IseynebQNuF24=
X-Google-Smtp-Source: APiQypJBPLVHh+khEqzaRN4BTLpEuERK6fnjt+5kSc4dHWU4I3WSPSVGkvIWG2WX6VYfjyn5bioAW45CFYQfoy9n4Nw=
X-Received: by 2002:a92:8752:: with SMTP id d18mr486885ilm.224.1589233297940;
 Mon, 11 May 2020 14:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rvp4JrER0RPp=VgYwYL87jntwW8vWNANzubH3Ah_8Oow@mail.gmail.com>
 <20200502001942.626523-1-Jason@zx2c4.com> <20200510211738.GA52708@sol.localdomain>
In-Reply-To: <20200510211738.GA52708@sol.localdomain>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 11 May 2020 15:41:27 -0600
X-Gmail-Original-Message-ID: <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com>
Message-ID: <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com>
Subject: Re: [PATCH v2] security/keys: rewrite big_key crypto to use Zinc
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Sun, May 10, 2020 at 3:17 PM Eric Biggers <ebiggers@kernel.org> wrote:
> The commit message should say "lib/crypto", not Zinc.  Nothing in the source
> tree actually says Zinc, so it will confuse people who haven't read all the
> previous discussions.

Old commit message from a few years ago. Will adjust.

>
> >               /* read file to kernel and decrypt */
> > -             ret = kernel_read(file, buf->virt, enclen, &pos);
> > +             ret = kernel_read(file, buf, enclen, &pos);
> >               if (ret >= 0 && ret != enclen) {
> >                       ret = -EIO;
> >                       goto err_fput;
> > +             } else if (ret < 0) {
> > +                     goto err_fput;
> >               }
>
> It would make sense to write this as the following, to make it consistent with
> how the return value of kernel_write() is checked in big_key_preparse():
>
>                 ret = kernel_read(file, buf, enclen, &pos);
>                 if (ret != enclen) {
>                         if (ret >= 0)
>                                 ret = -ENOMEM;
>                         goto err_fput;
>                 }

Will do, and will send a v3 with your reviewed-by.

Jason
