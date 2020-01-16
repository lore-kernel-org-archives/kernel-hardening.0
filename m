Return-Path: <SRS0=8b00=3F=lists.openwall.com=kernel-hardening-return-17575-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A983EC33CB7
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 18:14:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 119F02073A
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jan 2020 18:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jhtLpi9W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 119F02073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17575-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30320 invoked by uid 550); 16 Jan 2020 18:14:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30292 invoked from network); 16 Jan 2020 18:14:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4/SSgF43F8oOB5ed/Mu+sVQAJxuMOrgg0eXAd3RvzI=;
        b=jhtLpi9WlDS+egj1OpzohuuS9pQgMd5pKXv8LVi9TmM1esvDD/PbLI6+bFwE6vYUwl
         YbwYAIPyLL2iLWWFZ4ytb5/fY8kOXcb6A2/+9FD7Gi+C+JXHa3WLLW4PAc3A1LG6fGUB
         fcGO38CrloQAqONKKE9kyts4coCH7PcaZdcHpdbxmqab0w+fwQS/lEgAZr4mVDvHpJYZ
         zSX2xCdkYeoNMT4FCcjJ3ScoEaWXWSt7GQBFRFwgocvBKdk4BkZaxg5rW15RDuLSco8V
         obn4/UfOsChIVw5BO4a6LT+gT/AarmEyS+XJlpk0+EheBerIjl/hOt6iDgKZdetSZVhc
         J+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4/SSgF43F8oOB5ed/Mu+sVQAJxuMOrgg0eXAd3RvzI=;
        b=FTX2uwINAK+2kIGeTx/OJnUNueAs0F8ZMnvcbqChDgmuTFN0NTZf6CG+LWARsjbbZ4
         bDPXs+NP1eDH/KMePZprpYJWNOfd0ERvODalPs2sxNIbnDBqTxPsTxFTHmQMk77c8Q5c
         KEgRZgCyzDeGL6KoPr4LlRaqDhN3bTUYD/AqodNCeVL3kVLdmxK59sBuujCp8yB73Nz3
         /rmgSUAacH6df4DGYg5ORp+uz9waKllKQZeZKq8A1XAWYDJ8OT/FwbJz3SvMAlgQUbZK
         l4FPGtTsoHn06FrlbVWnvFQ0DPNl2g6MpnV/RiNbjBdRKS5vkHTsbLBftgfROMT9L9br
         lNrg==
X-Gm-Message-State: APjAAAVhkQTqyPuB3bHZU0ZwHKWP1/yf3dK6xf7wALkLfrA8OZJtG/UU
	thKty4n3J2oUUcTZZ4GhjEXSbDpSqMauH3vHbQZkdg==
X-Google-Smtp-Source: APXvYqxIIWRmLZKLxckIhAMKbhmdzDCTkxbmnPMWtT8X50l5n92iMdw1uWSvaleMeLdpwMB55APzs6jyZJod3pJATys=
X-Received: by 2002:ab0:422:: with SMTP id 31mr20481306uav.98.1579198475361;
 Thu, 16 Jan 2020 10:14:35 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com> <20191206221351.38241-13-samitolvanen@google.com>
 <20200116174648.GE21396@willie-the-truck>
In-Reply-To: <20200116174648.GE21396@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 16 Jan 2020 10:14:24 -0800
Message-ID: <CABCJKucWusLEaLyq=Dv5pWjxcUX7Q9dL=fSstwNK4eJ_6k33=w@mail.gmail.com>
Subject: Re: [PATCH v6 12/15] arm64: vdso: disable Shadow Call Stack
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 16, 2020 at 9:46 AM Will Deacon <will@kernel.org> wrote:
> Should we be removing -ffixed-x18 too, or does that not propagate here
> anyway?

No, we shouldn't touch -ffixed-x18 here. The vDSO is always built with
x18 reserved since commit 98cd3c3f83fbb ("arm64: vdso: Build vDSO with
-ffixed-x18").

Sami
