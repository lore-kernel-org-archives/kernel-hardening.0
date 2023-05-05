Return-Path: <kernel-hardening-return-21667-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 029F2C77B7C
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 May 2023 15:23:56 +0000 (UTC)
Received: (qmail 15740 invoked by uid 550); 5 May 2023 15:23:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15714 invoked from network); 5 May 2023 15:23:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1683300216; x=1685892216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/3vTohp91jiKKtxYYXC9sZ4oDT0Wvdf7xVOWIDy7Fk=;
        b=Bszl0DwZbz8s+myurjfDruThE0Fu8MhipC9cyx9FTy3XiZxkMKgFbm867G2C7RFNbT
         OJczRbftk7euoqYCIpgBXpuyjmZnTE8jpjOwFvJJ3s/14zLgxyQjZjhqwtzHVIeb9rHH
         h70UHwRlPMA2MUR8cG2u9TKfm7m10YDCj7ZelEEfzTiSLn15zDrDojwEIkVgmD5VnDSv
         HsR7FB2fKjU/MVKSotN/8UpkcEqIFiaiWiww4pIvKGNGUKhbKawbk1skibuLteTKnxCc
         y4Xn865xcSP3LUMtcRXSqSyY6lp9eAE99FUGbpcL32FJ0gHXsTQpLgKCjmDkPqmv4uJC
         8EbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683300216; x=1685892216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/3vTohp91jiKKtxYYXC9sZ4oDT0Wvdf7xVOWIDy7Fk=;
        b=Kt3sCFdFTwWTWq/23CXZsGPkUvequQQhBpr3g5V0avXSyUJxuAoN00K48IB6c+Wgms
         4mgmfeITCshiyQa3D0eglKXcLYPVjbJb/hZzNEnH8z48U4+OZeCEKSX42gBYQSPeG6tX
         J1Tof/zrRedF8tQE0rp6aAtHxfjWixmbCIi510BFQstuddZHXH/Is5CsAMGhmiqEF9P9
         ontJb7tD5/21yKunzN0tEGl8bP9CeCROCIqQkhYg6M1PnZbil5ZDKdyImDtKhP30XSTK
         uUIfq8RY9B10XTW1DlLGLpRZpABX3PTrI505iTOqI1MWxnUgxcHjaYDfz1tKJw3jbYQI
         M5gg==
X-Gm-Message-State: AC+VfDytUwGy7CZc6oNNJKNDazOiUYof5LkGvLblcd61pEHl2jIMoyg4
	JXvbL018tm6/QPNtsseGA/qLVo8J6zmj/m0ilvsM
X-Google-Smtp-Source: ACHHUZ57JDqGgS/uAWi4XXuD+Aw3Brz4iCdRPH0YMiqpZ3PYVd37YzF/qiHvizGQHZkqKkRe+0+w3obMHGqdV1gyjoM=
X-Received: by 2002:a81:138d:0:b0:559:f517:a72d with SMTP id
 135-20020a81138d000000b00559f517a72dmr2939441ywt.14.1683300215767; Fri, 05
 May 2023 08:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com> <87pm7f9q3q.fsf@gentoo.org> <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com>
In-Reply-To: <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 5 May 2023 11:23:24 -0400
Message-ID: <CAHC9VhTX3ohxL0i3vT8sObQ+v+-TOK95+EH1DtJZdyMmrm3A2A@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
To: David Hildenbrand <david@redhat.com>
Cc: Sam James <sam@gentoo.org>, Michael McCracken <michael.mccracken@gmail.com>, 
	linux-kernel@vger.kernel.org, serge@hallyn.com, tycho@tycho.pizza, 
	Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Iurii Zaikin <yzaikin@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 5, 2023 at 11:15=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
> On 05.05.23 09:46, Sam James wrote:
> > David Hildenbrand <david@redhat.com> writes:
> >> On 04.05.23 23:30, Michael McCracken wrote:
> >>> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_spac=
e
> >>> sysctl to 0444 to disallow all runtime changes. This will prevent
> >>> accidental changing of this value by a root service.
> >>> The config is disabled by default to avoid surprises.

...

> If we really care, not sure what's better: maybe we want to disallow
> disabling it only in a security lockdown kernel?

If we're bringing up the idea of Lockdown, controlling access to
randomize_va_space is possible with the use of LSMs.  One could easily
remove write access to randomize_va_space, even for tasks running as
root.

(On my Rawhide system with SELinux enabled)
% ls -Z /proc/sys/kernel/randomize_va_space
system_u:object_r:proc_security_t:s0 /proc/sys/kernel/randomize_va_space

--=20
paul-moore.com
