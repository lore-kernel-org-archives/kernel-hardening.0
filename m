Return-Path: <SRS0=afZs=GG=lists.openwall.com=kernel-hardening-return-20610-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A80C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun,  3 Jan 2021 14:39:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6CE2220720
	for <kernel-hardening@archiver.kernel.org>; Sun,  3 Jan 2021 14:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CE2220720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=daurnimator.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20610-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20071 invoked by uid 550); 3 Jan 2021 14:39:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16056 invoked from network); 3 Jan 2021 14:27:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daurnimator.com; s=daurnimator;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdyQdxurFTWyieFqx40CmBAoJaRWHmu1pRJJqDh4s5U=;
        b=JHNprKCEMlJgPWrm5Lf8OKHrWDbu4cEkVI6wyETQU0N7Fi8v5Ypp/+nkY/AH2GR/xs
         03HCcW+FEV5VDByHaCH5AKFMjTu24gF7Gq4q8kPosYWDGBO0gm97o3VYffDbTGaInjOZ
         Sa8FL0FLEOy5wkVQ2SJe2vxdz1vPL9rcg8DYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdyQdxurFTWyieFqx40CmBAoJaRWHmu1pRJJqDh4s5U=;
        b=XEEok4jkROoqNCsyBaqCG032WNWXxgaF0vxi9XbTGbfKBh7W+wkFsIMmvSOUqVwGfj
         2LkcAx5ZiwUB6CYLxf7AWWFqD+cmNaHfNE8SEQ2zAeciHIkKVFhOPLbFhwFT8IiMym1U
         RlVt7QsTGyzagJUM/IyBzO5Z3soAlAj46y9D2RM4q2oKkuFFH8rY4GDbL3YSjPhTMLaT
         t9ZSodfF/6y2KdrpDvqVzeGhwHsMoI6U3jvsJIhhitR9Ea7V/OPJl6+VfpsrgZ4nfR5R
         gHTC/9nqjO45AA5VZ2h/Dvai4GRNoUg9R+HDLdgktJPGWOVv9lFbQ0ftIprCq24aWpIN
         iSrg==
X-Gm-Message-State: AOAM530I5YJb63SmB0/Wg2CQnkjNJE3beBtw4/VLjLfDqPw9Bq/H+m4N
	P+8yPIR94xoTA+FXAG0Ji17kR++NlLzFGkvlZuauXQ==
X-Google-Smtp-Source: ABdhPJwFlghKT98/Z0lh6E4GwRePMZJ+jb52otf0aNEGyGaXkWUSRiOfpQxV7ZsIBGH2niNmnsTYvIahv/eJODbOWn0=
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr23264936wml.50.1609684012066;
 Sun, 03 Jan 2021 06:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20200827145831.95189-1-sgarzare@redhat.com> <20200827145831.95189-3-sgarzare@redhat.com>
In-Reply-To: <20200827145831.95189-3-sgarzare@redhat.com>
From: Daurnimator <quae@daurnimator.com>
Date: Mon, 4 Jan 2021 01:26:41 +1100
Message-ID: <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Christian Brauner <christian.brauner@ubuntu.com>, io-uring <io-uring@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>, Aleksa Sarai <asarai@suse.de>, 
	Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Aug 2020 at 00:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
> +               __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */

Can you confirm that this intentionally limited the future range of
IORING_REGISTER opcodes to 0-255?
