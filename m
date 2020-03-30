Return-Path: <SRS0=SRx3=5P=lists.openwall.com=kernel-hardening-return-18307-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E7C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 15:59:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 182A62072E
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 15:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzK2lWWd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 182A62072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18307-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30454 invoked by uid 550); 30 Mar 2020 15:59:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30422 invoked from network); 30 Mar 2020 15:59:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NuRQyN7bkkSmBmFvAy2z0wm04WnOnH5g3Y1VtvXKj34=;
        b=HzK2lWWdP4vOW+qIWpbtImtmVgtaVNGYb42cvwDT7UPKE7UchqODMo4mB7tCUWN8Rf
         kLfj4vRbwxPMcnGOraeq99twiX+S5GRQSZipBxbtTxcAy6EBgaY65dNuSd83TQGgDcUM
         0UNRQedln0j/4mEhT8r12/PVE6Je4HnB9nWTiyIX+tlqkgQVIUJxvU7qVGn1oGhyILlK
         sQWfdySX2Vqi265aVRF1hUiG95s0awJyFYTluFybNvyD1PyLpNuIoXn+0NDa3dJNghER
         b63977W1MW7gFcwUn9RT5BYw/tkQD6EiQbMOzJCxcPe2oReur7MQEhGhwbS6tkM7S3Rq
         9nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NuRQyN7bkkSmBmFvAy2z0wm04WnOnH5g3Y1VtvXKj34=;
        b=rxc6QmuYUW9gcr5ftCGCF4McJQhqzsAEFZg7UO0Xwbz2OEYb7lGDLjENzHUcXYKz5s
         LyLdFLlUfGBa8gVgpxll+claIY+dvDrgjUCB0rPEGAIzAW5O0YyrcZN2LSm50Qq+OvVg
         FQXfNnCKgumJOKHkFSWJRu8y3VlZ8U+l38IUhRH+P8nnZDp0g0m7K/TX9ghDJRzR5D8D
         9uBgYjTcpIKvk327FSXGC8JCaHT37l82KbjXTHVVXwmTyRK/DQIuylwGp1UcBalNnUtw
         j0/ad8+lby0X4WepRExija6sIcewp8lCkXS2gqGPyJ6aN7uVlPD81VtR9mr/atdGzWov
         yRPg==
X-Gm-Message-State: AGi0PuaV5mH7qItBx6OSJFd26CeNb61P54I1yYsvl+p4VXGk0cww0p+9
	ghd2VYMX+JeOdePjKH5l0oWU+yaiwtJmiSIvkHI=
X-Google-Smtp-Source: APiQypI48b9gxH6USfZ1wCD0YTX6TAVIFPaOX5QPlhyv7Iy6s4hZaocuj1rQc24NI1rYnXKNmERI+Ey73cydO1Zhsgk=
X-Received: by 2002:a2e:7805:: with SMTP id t5mr7826197ljc.144.1585583974562;
 Mon, 30 Mar 2020 08:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
In-Reply-To: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 30 Mar 2020 08:59:23 -0700
Message-ID: <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
To: Jann Horn <jannh@google.com>
Cc: bpf <bpf@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
>
> I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
> of CONFIG_GCC_PLUGIN_RANDSTRUCT.

Is it a theoretical stmt or you have data?
I think it's the other way around.
gcc-plugin breaks dwarf and breaks btf.
But I only looked at gcc patches without applying them.
