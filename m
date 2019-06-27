Return-Path: <SRS0=knJQ=U2=lists.openwall.com=kernel-hardening-return-16282-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BB7C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 10:06:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7AEA2083B
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 10:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WJWfF4PV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7AEA2083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16282-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15576 invoked by uid 550); 27 Jun 2019 10:06:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15550 invoked from network); 27 Jun 2019 10:06:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d3Ru/epqcKSdd6urtlGQx+RBPxT9C1o3y8n/GaRj0IQ=;
        b=WJWfF4PVo0+95PvGT5hg2e4Xeu/u3T/2L4nJe69VTor4JJVxeDdlqbkIbil08BQcFq
         4WNizc0907sGpZ4DC8lCEjX+TqmlXc6gNLvaAixKpQpcDzXZ/csQnyTyJ9LyWnlKP5XK
         DfzkoEGW0SfvupgEB+clKSA6s//2MV85T08hiVgG34Mr+wMKt1v7ZYUd4D5ntgPfiIWT
         BQIO/8nMl3PMVW49ehtZAe939r/ma8rq5oFi0/exvVxF+r/wj/vRmU7YNMfyJa4c2yiW
         3wy4T1Z6Y7C0Nl2uGzKVuMCPOreBitQMkM5u9hBPZtV3zoOH/jyJBhyExmyBNM5uutqZ
         op6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d3Ru/epqcKSdd6urtlGQx+RBPxT9C1o3y8n/GaRj0IQ=;
        b=FZOfGZkc6Fym8hifhlnsF69pNawtqNNoa3Dt2kkuu5jIjk7ifLJs/YbdB5T3wV4LiT
         42siV0+Kn5pijLARHDd5Pp5AA2a+LrQXDR9lwQlczUAu+KNhA8nbIum3Ykkb3++MgkVl
         F+tiuWf7iPVcEKABFJ251EIL7JED3kS2JOPcTW8tKd98DCeH+u6F2PcJzArTVC6tWq4k
         L6pE6xSEh6z+Fx/luG9EnTH94R4b5gQCWtQtKsLgTrObzVyrUgOvUCQoQNee/I8/Uyst
         JDG4puNbT7I/09Thy4z+MeqJQ1j25ENRR9ZI/cgmQavVz49rToyhYpUE/jwAPi1oYI5z
         jp4A==
X-Gm-Message-State: APjAAAXwlvdgHNKGJUE5VfqVO4Y3iXWRZ8TCrI3yFpgVuLErgKsosPNF
	uWMFDAmMpcfab6y3WXLCsTkKqXGXBquaVzBkSFEJgQ==
X-Google-Smtp-Source: APXvYqy57wqyZI8LbJdgFCXKbEYhDUuoxxAgY0BAe68utv9cKzvGiUTExbd/UyfLgBKJ4hy2WFzLkW2oZMYLWpxsMYo=
X-Received: by 2002:ab0:64cc:: with SMTP id j12mr1845628uaq.110.1561629965902;
 Thu, 27 Jun 2019 03:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com> <20190626121943.131390-2-glider@google.com>
 <20190626162835.0947684d36ef01639f969232@linux-foundation.org>
In-Reply-To: <20190626162835.0947684d36ef01639f969232@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 27 Jun 2019 12:05:54 +0200
Message-ID: <CAG_fn=XF1C-3CCKGCHTrgCtcsh-u390hjM=rp5ZRv3ijTH5YgQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2019 at 1:28 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Wed, 26 Jun 2019 14:19:42 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> >  v8:
> >   - addressed comments by Michal Hocko: revert kernel/kexec_core.c and
> >     apply initialization in dma_pool_free()
> >   - disable init_on_alloc/init_on_free if slab poisoning or page
> >     poisoning are enabled, as requested by Qian Cai
> >   - skip the redzone when initializing a freed heap object, as requeste=
d
> >     by Qian Cai and Kees Cook
> >   - use s->offset to address the freeptr (suggested by Kees Cook)
> >   - updated the patch description, added Signed-off-by: tag
>
> v8 failed to incorporate
>
> https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_a=
lloc=3D1-and-init_on_free=3D1-boot-options-fix.patch
> and
> https://ozlabs.org/~akpm/mmots/broken-out/mm-security-introduce-init_on_a=
lloc=3D1-and-init_on_free=3D1-boot-options-fix-2.patch
>
> it's conventional to incorporate such fixes when preparing a new
> version of a patch.
>

Ah, sorry about that.
I'll probably send out v9 with proper poison handling and will pick
those two patches as well.
--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
