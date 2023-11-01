Return-Path: <kernel-hardening-return-21719-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id CA962C4167B
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Nov 2023 16:24:15 +0000 (UTC)
Received: (qmail 1203 invoked by uid 550); 1 Nov 2023 16:24:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1165 invoked from network); 1 Nov 2023 16:24:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698855830; x=1699460630; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoRbzGRAnQty7H13YdGej79QgL+EU0noB4+Qr1wy+V0=;
        b=rLGZ5ozJ8Ig/jHhevfybdCcdI8497cIyz2Et+y9AaMqYe0CPpvKOg6jjI4wql4enWq
         XyIWHsX3ynXkjhA25ljDiCJgdSlqC+tsDdPMzKvshLYAj2LHRPy9hvwmJWW0hWVRKuak
         yObJAJ52w9h14fhVqlTUKU9rPFPJOVa5tQkPKg2UsT614HCCy1XqhPo08Xrkjy4Lu6br
         hv+gcjnApGUgh5yKamt/55DCMicem4ePJOSxl7F32otOAwv8Sv7vw+XOlAEWoXwAxxY6
         liwFR1MyDVB1KfXJxzb3PmgE3bKM4Di/okztMsAVH7eEM6OugtCrzvNqcu8Goj0t0Ubl
         wr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698855830; x=1699460630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uoRbzGRAnQty7H13YdGej79QgL+EU0noB4+Qr1wy+V0=;
        b=wmDM55A0rGH+P4cq6Fm5KUTnFIf7U10HCNnMTTFz5AgMvDZS+Kn8XK3FAg+sybg6v8
         mrKLbY5VoOKkZXwUDiJAB8aw1HW1CPOnVP3YtS6mEzvcsvQiw9+FSCwox+WM+jHDtEHz
         vBRu3JHCg5wxyyr5+WCN9quJLesfh5v0Xwe/OdD85FXsnzV2818qmRvLKjt5Bk6TuCJ8
         us7LBl254RGlCXJVKzQTZe1gqJT+hheBpivevOVc8MzADhFBxSmjTa9ADaZcX5H1rdxn
         T7rrZZL8s8k4p0ieWSdlcms8Vi5GRInJ6CXqDISUivVuHPiplmFVZPz+cvVVmgWjLcl1
         CLiA==
X-Gm-Message-State: AOJu0YzHeXqQrWBdZTdspXXOQCD87iZHihNGcauyxTYVaaJjaMvI65kV
	hpY2befwmCa4qnyUyJOwI8FPD+Et1OBc7cI1BRIOzg==
X-Google-Smtp-Source: AGHT+IGDG43OvjOvSZ1G9d15u19P4ARTOgNs/LGmiDYoHslrS9Gutvb89Z1DejMyuF4UMP8kxPHI3i/yBGTUv8+4se0=
X-Received: by 2002:a50:d0de:0:b0:543:5119:2853 with SMTP id
 g30-20020a50d0de000000b0054351192853mr255080edf.6.1698855829665; Wed, 01 Nov
 2023 09:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
 <CAHC9VhRCJfBRu8172=5jF_gFhv2znQXTnGs_c_ae1G3rk_Dc-g@mail.gmail.com>
 <20231024141807.GB321218@mail.hallyn.com> <CAHC9VhQaotVPGzWFFzRCgw9mDDc2tu6kmGHioMBghj-ybbYx1Q@mail.gmail.com>
 <20231024160714.GA323539@mail.hallyn.com> <ZUFmW8DrxrhOhuVs@mailbox.org> <20231101.eeshae5Ahpei@digikod.net>
In-Reply-To: <20231101.eeshae5Ahpei@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Wed, 1 Nov 2023 17:23:12 +0100
Message-ID: <CAG48ez0wQ3LFxZ2jWj1sTZngTg4fEmx1=dXYuRbMMFk5CiYVbg@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Stefan Bavendiek <stefan.bavendiek@mailbox.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 11:57=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
> On Tue, Oct 31, 2023 at 09:40:59PM +0100, Stefan Bavendiek wrote:
> > On Tue, Oct 24, 2023 at 11:07:14AM -0500, Serge E. Hallyn wrote:
> > > In 2005, before namespaces were upstreamed, I posted the 'bsdjail' LS=
M,
> > > which briefly made it into the -mm kernel, but was eventually rejecte=
d as
> > > being an abuse of the LSM interface for OS level virtualization :)
> > >
> > > It's not 100% clear to me whether Stefan only wants isolation, or
> > > wants something closer to virtualization.
> > >
> > > Stefan, would an LSM allowing you to isolate certain processes from
> > > some abstract unix socket paths (or by label, whatever0 suffice for y=
ou?
> > >
> >
> > My intention was to find a clean way to isolate abstract sockets in net=
work
> > applications without adding dependencies like LSMs. However the entire =
approach
> > of using namespaces for this is something I have mostly abandoned. LSMs=
 like
> > Apparmor and SELinux would work fine for process isolation when you can=
 control
> > the target system, but for general deployment of sandboxed processes, I=
 found it
> > to be significantly easier (and more effective) to build this into the
> > application itself by using a multi process approach with seccomp (Basi=
cally how
> > OpenSSH did it)
>
> I agree that for sandbox use cases embedding such security policy into
> the application itself makes sense. Landlock works the same way as
> seccomp but it sandboxes applications according to the kernel semantic
> (e.g. process, socket). The LSM framework is just a kernel
> implementation detail. ;)

(Related, it might be nice if Landlock had a way to completely deny
access to abstract unix sockets, and a way to restrict filesystem unix
sockets with filesystem rules... LANDLOCK_ACCESS_FS_MAKE_SOCK exists
for restricting bind(), but I don't think there's an analogous
permission for connect().

Currently, when you try to sandbox an application with Landlock, you
have to use seccomp to completely block access to unix domain sockets,
or alternatively use something like the seccomp_unotify feature to
interactively filter connect() calls.

On the other hand, maybe such a feature would be a bit superfluous
when we have seccomp_unotify already... idk.)
