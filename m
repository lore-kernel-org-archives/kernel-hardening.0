Return-Path: <SRS0=G/Kn=O3=lists.openwall.com=kernel-hardening-return-21425-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E045C433F5
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 19:26:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7814B60F41
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 19:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7814B60F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7416 invoked by uid 550); 7 Oct 2021 19:26:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7396 invoked from network); 7 Oct 2021 19:26:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NZdCC7CS4dz4WubheIViknJtIIkaL8xCwtFH+zR8MvM=;
        b=eHzzunjEiw0c49/WWP7ttbNMcB3anVXl2I3BhWlHxCkAgfUZJaQlEQ4yj49eW+O5Qd
         V/tr9/w7+oeASdwfi2gPR+2A9dR5TzHngo0qjndDetXgsqoAB1QXDYqUefhEG8akLtkm
         NXtn7bxmsTq3rNyvns/y2bVgOPK39DmHni93s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NZdCC7CS4dz4WubheIViknJtIIkaL8xCwtFH+zR8MvM=;
        b=sCOv92jZYfgu0uPqWYrMqJQrUXduPTyATwnXh+7Kx1MNaIhyzWufx5OUk95IMiAl3e
         bFzxWCsANgc3+i2e25upR9I+8SoXTeN0PjIXpFJVFomIDGPer9/bEqiefMa5cx9se9Wv
         FfdQyNSzkH7mnEbk29PwQNwS9N4PqIqLzb3cDdI4hE5B6614sZol6AJrDEA0G8MwKRUE
         JxeJQBlS7YvF63z79e+UeMAcmEbgrtrMg4Om1zbbuVAz9hSsRj4ECguDnyuxIgxKgluW
         vmw4YV8BfwSxh0ndsc2EREprFKGok++LguApI1NfdMdya7UTyrcbvG0u8Mtwd42pceum
         3rdw==
X-Gm-Message-State: AOAM5307uQ/jfeQ3EQTfmG2xejpocDBK31wVcfpqvz0JZpTz6i7W5JNA
	iAzX+U6S9lSvYX8d7Ypjz5uxSw==
X-Google-Smtp-Source: ABdhPJx4Tw35x1xl9BQYB1be7fBA/xGCyy08poTnjhSNtRNoa/m8AG/GdRnhqGS7ZQ1VLaYiOhqwvw==
X-Received: by 2002:a17:90a:6b4d:: with SMTP id x13mr2840636pjl.208.1633634780607;
        Thu, 07 Oct 2021 12:26:20 -0700 (PDT)
Date: Thu, 7 Oct 2021 12:26:19 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v13 2/3] arch: Wire up trusted_for(2)
Message-ID: <202110071226.750297A@keescook>
References: <20211007182321.872075-1-mic@digikod.net>
 <20211007182321.872075-3-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211007182321.872075-3-mic@digikod.net>

On Thu, Oct 07, 2021 at 08:23:19PM +0200, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Wire up trusted_for(2) for all architectures.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
