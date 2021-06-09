Return-Path: <SRS0=6VqT=LD=lists.openwall.com=kernel-hardening-return-21295-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91404C48BCF
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Jun 2021 16:52:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B8B8A61354
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Jun 2021 16:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8B8A61354
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21295-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3447 invoked by uid 550); 9 Jun 2021 16:52:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3417 invoked from network); 9 Jun 2021 16:52:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LD9HSxwVBYD4Eigmm4/eFaSooe5X81yBa6b9diyTxLk=;
        b=N47Q7iKRccjNkYwWKqUHqFn73mIgkb6yUnEgVpfiCnpd7KGAo+RwkJGh7fCyhsJ5rJ
         PHoctqrgLpYFlXiogoGImI85Yu3OsLM3sfJYRnwP4OzsOAGtIgoKDG+IYVT+VOE0fTE/
         27PJSIvlhBf+evKmhRLXx/yOa0KOermG9co7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LD9HSxwVBYD4Eigmm4/eFaSooe5X81yBa6b9diyTxLk=;
        b=QrnvFslRtGNU7q/WnsVNtCKYUr5/bvoHQfAZ/HcdJE8PD8+2OsHKr7WGF0jOhfIndj
         PEdKqnPh2zvIQVvaXEYdLjvLI/igCySYDYB5VryqcZd7lG1dRNf0P5KmGBktijwum9mT
         Db7uz0Vhs+IH4ImC4ZB7nBQZxb68Z0AD5aD0+Ch28iQmmlnalPaJlRUhncp1m/KZcGSV
         NWZ0veRwvXnj3LiUVdAmekkPZ5aWq1y8htJ+JAg3BJ7RoN3xDb2m1AAX7xsBs3ADeKrv
         ao5iPK/IlNtmMEmkq63RyC1CtNpkFE46l1q7Kgf4n2pur3IAm29BRS81C9k8ave0zv39
         XpUQ==
X-Gm-Message-State: AOAM531AlTEyJGJ3n5Nk8NpkJyxsuoPeOU32pyluP3/+HSJ7UR+ylevg
	HFr4nzKPRO2FD86IfMjoFrpIeg==
X-Google-Smtp-Source: ABdhPJzNXeQzlTinS1wmW8MEliQZalVLosypCXm6YUl9Lebh2/tT7cpsPFLagkE3mdC+ClBbYzFVAQ==
X-Received: by 2002:a17:902:988f:b029:114:12d2:d548 with SMTP id s15-20020a170902988fb029011412d2d548mr479973plp.73.1623257550841;
        Wed, 09 Jun 2021 09:52:30 -0700 (PDT)
Date: Wed, 9 Jun 2021 09:52:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>, valdis.kletnieks@vt.edu,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 0/8] Fork brute force attack mitigation
Message-ID: <202106090951.8C1B5BAD@keescook>
References: <20210605150405.6936-1-john.wood@gmx.com>
 <202106081616.EC17DC1D0D@keescook>
 <cbfd306b-6e37-a697-ebdb-4a5029d36583@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbfd306b-6e37-a697-ebdb-4a5029d36583@linux.intel.com>

On Tue, Jun 08, 2021 at 04:38:15PM -0700, Andi Kleen wrote:
> 
> On 6/8/2021 4:19 PM, Kees Cook wrote:
> > On Sat, Jun 05, 2021 at 05:03:57PM +0200, John Wood wrote:
> > > [...]
> > > the kselftest to avoid the detection ;) ). So, in this version, to track
> > > all the statistical data (info related with application crashes), the
> > > extended attributes feature for the executable files are used. The xattr is
> > > also used to mark the executables as "not allowed" when an attack is
> > > detected. Then, the execve system call rely on this flag to avoid following
> > > executions of this file.
> > I have some concerns about this being actually usable and not creating
> > DoS situations. For example, let's say an attacker had found a hard-to-hit
> > bug in "sudo", and starts brute forcing it. When the brute LSM notices,
> > it'll make "sudo" unusable for the entire system, yes?
> > 
> > And a reboot won't fix it, either, IIUC.
> > 
> The whole point of the mitigation is to trade potential attacks against DOS.
> 
> If you're worried about DOS the whole thing is not for you.

Right, but there's no need to make a system unusable for everyone else.
There's nothing here that relaxes the defense (i.e. stop spawning apache
for 10 minutes). Writing it to disk with nothing that undoes it seems a
bit too much. :)

-- 
Kees Cook
