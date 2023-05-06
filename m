Return-Path: <kernel-hardening-return-21668-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9B35AC7EE22
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 May 2023 07:05:25 +0000 (UTC)
Received: (qmail 25729 invoked by uid 550); 6 May 2023 07:05:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25709 invoked from network); 6 May 2023 07:05:12 -0000
X-CMAE-Analysis: v=2.4 cv=Lo1UiFRc c=1 sm=1 tr=0 ts=6455fc1c
 a=9JKJlijexIvT1S7cpBUTgA==:117 a=IkcTkHD0fZMA:10 a=P0xRbXHiH_UA:10
 a=xVhDTqbCAAAA:8 a=20KFwNOVAAAA:8 a=rDwt1Zk6MRkbpbuKzqYA:9 a=QEXdDO2ut3YA:10
 a=GrmWmAYt4dzCMttCBZOh:22
X-SECURESERVER-ACCT: kaiwan@kaiwantech.com
X-Gm-Message-State: AC+VfDzFVTC+L4jjEr1ns5uUTIkTcIssQ9x9Pz4t6WhJVDrZhGnRnKBW
	0OMz4ERyrQdpu1ACpIZFHUHThMvoRljcokPzQOQ=
X-Google-Smtp-Source: ACHHUZ62GVBTMauDj5I48KnvfLs0gNpt0Jrh6TAkoSyEVAeNlL8OxCphSpqv3XTKacR+8uhZXSKmFENDlCZxOsMFjyw=
X-Received: by 2002:a17:907:70a:b0:953:9024:1b50 with SMTP id
 xb10-20020a170907070a00b0095390241b50mr2753174ejb.74.1683356699105; Sat, 06
 May 2023 00:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com> <87pm7f9q3q.fsf@gentoo.org>
 <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com> <CAHC9VhTX3ohxL0i3vT8sObQ+v+-TOK95+EH1DtJZdyMmrm3A2A@mail.gmail.com>
In-Reply-To: <CAHC9VhTX3ohxL0i3vT8sObQ+v+-TOK95+EH1DtJZdyMmrm3A2A@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Sat, 6 May 2023 12:34:41 +0530
X-Gmail-Original-Message-ID: <CAPDLWs-=C_UTKPTqwRbx70h=DaodF8LVV3-8n=J3u=L+kJ_1sg@mail.gmail.com>
Message-ID: <CAPDLWs-=C_UTKPTqwRbx70h=DaodF8LVV3-8n=J3u=L+kJ_1sg@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
To: Paul Moore <paul@paul-moore.com>
Cc: David Hildenbrand <david@redhat.com>, Sam James <sam@gentoo.org>, 
	Michael McCracken <michael.mccracken@gmail.com>, linux-kernel@vger.kernel.org, 
	serge@hallyn.com, tycho@tycho.pizza, Luis Chamberlain <mcgrof@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfLkflY78BI8MY6gKI20/XCHUV+Pz0O8qyh1taIvxmYimJe0WdrlWik2Z8jgSzTlpkvl4AN2/sV1NEA18lAyiggLUWjEPMTQzTJj2BpmUN5Qcc92ekD2m
 34UN0NF5zse+FuNZT1DuG1EKN4lPJ1kxQ1amC0VT3xZlTUWQ5FDZh7b42/R82aXuFl40CuCGrzkfM7NR8yxRmWkVGUyNtVvrKhQ1HfkWV1K4dpQZ4HIo2fqG

On Fri, May 5, 2023 at 8:53=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
>
> On Fri, May 5, 2023 at 11:15=E2=80=AFAM David Hildenbrand <david@redhat.c=
om> wrote:
> > On 05.05.23 09:46, Sam James wrote:
> > > David Hildenbrand <david@redhat.com> writes:
> > >> On 04.05.23 23:30, Michael McCracken wrote:
> > >>> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_sp=
ace
> > >>> sysctl to 0444 to disallow all runtime changes. This will prevent
> > >>> accidental changing of this value by a root service.
> > >>> The config is disabled by default to avoid surprises.
>
> ...
>
> > If we really care, not sure what's better: maybe we want to disallow
> > disabling it only in a security lockdown kernel?
>
> If we're bringing up the idea of Lockdown, controlling access to
> randomize_va_space is possible with the use of LSMs.  One could easily
> remove write access to randomize_va_space, even for tasks running as
> root.
IMO, don't _move_ the sysctl to LSM(s). There are legitimate scenarios
(typically debugging) where root needs to disable/enable ASLR.
I think the key thing is the file ownership; being root-writable takes
care of security concerns... (as David says, if root screws around we
can't do much)..
If one argues for changing the mode from 0644 to 0444, what prevents
all the other dozens of sysctls - owned by root mind you - from not
wanting the same treatment?
Where does one draw the line?
- Kaiwan.
>
> (On my Rawhide system with SELinux enabled)
> % ls -Z /proc/sys/kernel/randomize_va_space
> system_u:object_r:proc_security_t:s0 /proc/sys/kernel/randomize_va_space
>
> --
> paul-moore.com
