Return-Path: <SRS0=SeUe=XV=lists.openwall.com=kernel-hardening-return-16945-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA19C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 15:32:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 26FE8222C9
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 15:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="jeIGSlfn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26FE8222C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16945-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1366 invoked by uid 550); 26 Sep 2019 15:31:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1348 invoked from network); 26 Sep 2019 15:31:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hn2BKNpEDnETMG1vl6OlBxnJv0OsEgm43gqddiFd3L8=;
        b=jeIGSlfnHuHWOnlWJUXcqKnbIdtnf3eWKQxCunNgHckAhzlBxayQpkTC8CGsAocTzR
         28l759p4wcIfkD8PTb8w7tHgWMTGhcKFEsdSYyVn3Ol2Tva1qSdQHvrK2kJzzzTR0M4X
         R4d8clVtGay4RTZN+AK8muNTkRnzt3q/gnBVFX+5h8icTy35ERDgxU4ZHsnlSrRo7qK+
         /5SheILQ9oO3DrsBO/zby3bauJC8AtCYXfuBQSAD17b7qB4PivNmnBjvwZUWyMKR0vlf
         RsdO39Es8vsQ50QKJpBDd9ZdQcRqUiTLr5+LwBqHO1ctMg8Fi2k6SCZETaqVkT0K1eGt
         xFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hn2BKNpEDnETMG1vl6OlBxnJv0OsEgm43gqddiFd3L8=;
        b=qK/VMndg9ZGNBlH99R8hHKfD5CAF8vHl3uCqQluvz5bvFAqys2FQPFRrvJwKqSDVlE
         T7nyKbJcoYkTFm9gGGSRwbC/SsspOgLeOwizzMuCXeJ6gDTU2o/ltkqZiEbOZhQkZL8c
         UkcM2E8VBGK50Ta13gANL+v7i3mhO7K8MDchDDWnZtMv3K6HASOid9E2IAF2T0fPHNA+
         RwCS1I0dZI7gc2IMxIxv/YCJuZamxQkzvi6c2HoEaPL5kXxgwZmmkDBiR5tagCSbc459
         hmuN7R3JKIE4i8Td4uXLBMNXTxGqf7Ux0aNiZCcN0BSUVhMIsyV886m7ooYjY09KScl6
         0mCg==
X-Gm-Message-State: APjAAAVdul5ZhwSIkXL+dDW8ioxet7MUQk+KDy3klWbFzm3D2MF+piSL
	Mm/v31PwP/NFF3iXW/TJYSXNHVVntpPN1m5SZ4tl
X-Google-Smtp-Source: APXvYqzWZrnFx6WcIfnXVd8l3472Lw3xc7e+WWjTgm0YDldFz3u6OHTdrHgyM65PbAKbGJQkQjJelej7+XCsPXOygvw=
X-Received: by 2002:a2e:7c09:: with SMTP id x9mr2988571ljc.87.1569511904242;
 Thu, 26 Sep 2019 08:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <201909251348.A1542A52@keescook>
In-Reply-To: <201909251348.A1542A52@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 26 Sep 2019 11:31:32 -0400
Message-ID: <CAHC9VhRNmWw1__-haD1ZEekADTho3EJyXQMd6ETpOv4c8Qn9nw@mail.gmail.com>
Subject: Re: [PATCH] audit: Report suspicious O_CREAT usage
To: Kees Cook <keescook@chromium.org>, sgrubb@redhat.com
Cc: linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= <jeremie.galarneau@efficios.com>, 
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com, 
	akpm@linux-foundation.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2019 at 5:02 PM Kees Cook <keescook@chromium.org> wrote:
>
> This renames the very specific audit_log_link_denied() to
> audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> report the fifo/regular file creation restrictions that were introduced
> in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> regular files"). Without this change, discovering that the restriction
> is enabled can be very challenging:
> https://lore.kernel.org/lkml/CA+jJMxvkqjXHy3DnV5MVhFTL2RUhg0WQ-XVFW3ngDQO=
dkFq0PA@mail.gmail.com
>
> Reported-by: J=C3=A9r=C3=A9mie Galarneau <jeremie.galarneau@efficios.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is not a complete fix because reporting was broken in commit
> 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> audit_dummy_context")
> which specifically goes against the intention of these records: they
> should _always_ be reported. If auditing isn't enabled, they should be
> ratelimited.
>
> Instead of using audit, should this just go back to using
> pr_ratelimited()?

I'm going to ignore the rename and other aspects of this patch for the
moment so we can focus on the topic of if/when/how these records
should be emitted by the kernel.

Unfortunately, people tend to get very upset if audit emits *any*
records when they haven't explicitly enabled audit, the significance
of the record doesn't seem to matter, which is why you see patches
like 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
audit_dummy_context").  We could consider converting some records to
printk()s, rate-limited or not, but we need to balance this with the
various security certifications which audit was created to satisfy.
In some cases a printk() isn't sufficient.

Steve is probably the only one who really keeps track of the various
auditing requirements of the different security certifications; what
say you Steve on this issue with ANOM_CREAT records?

--=20
paul moore
www.paul-moore.com
