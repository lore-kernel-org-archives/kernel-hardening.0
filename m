Return-Path: <SRS0=33FL=XB=lists.openwall.com=kernel-hardening-return-16867-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F6BC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 21:27:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3B842081B
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 21:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="r9+0Nr8W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3B842081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16867-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26162 invoked by uid 550); 6 Sep 2019 21:27:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26142 invoked from network); 6 Sep 2019 21:27:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wrOUeKLOBiJ84ary/XbohFbZ13Zk1ML2RYjXdtdAXc8=;
        b=r9+0Nr8WSDe0BeX/xgAvWhVEvW9tH0MuECx4aYmadpoy+3AFNgE6P9zxnYbpi57Qg7
         oi8mXEOkBqQuZ1KEtgbaT+Pl2O1KbPwC6Vc3Hjpv81mmG+Dl0F6ElTIY2un5As6UNNd8
         1Nr6igDyk8LhIW78BM3pgjMt6zvMStcW3LOt64HlJVN6uQhJdt6goRVp3jM5WH/6pv2S
         bMbj9IcbdmWNBc7L0ckUq4/u2TCeVPxp8MB/7bohTe03clXVLIJki9/BahI4idCJLobh
         H6szFVATb+QD+ne0aA7JwOOrYm0C5HsO4tg2YjOsgyf2nHjIT91yC15X7Jgl3N6l+cFz
         GTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wrOUeKLOBiJ84ary/XbohFbZ13Zk1ML2RYjXdtdAXc8=;
        b=G83PYMcaOkyX2NhpAFJClfMQcgbq0kctHMaIFgN70aJbdCjyXpYcJa+e9HjD2LVy0Z
         jQQ8XRGxytg4aoxmwfasI6/dy5wThE7lqT1/6XPw7Fk8I6+zpO1KHxjBQU/CnYOj5Xlx
         kjKkX1VlPFF+FLKXbmefG5gnez0NOfj4TxkqREXgJLjC2Sn7C+3i63640AoAChtwo4+f
         j5ch1YFVMjxM/1jwRCNOlYqdokE72u+1j4k6IQrCuUWnK1CBNtZKGVR3EAn7J58yngXW
         vkjMCkbwYU4ryWjw+ARPycHZQJ1ynGJuhkJeyNmCNxXO3bCcPLuDIRhvPghbwwjc8Cvx
         0igw==
X-Gm-Message-State: APjAAAUZ7N0Gv7u5gDYCSAV8AKsbqiuDf+eAmkG8V6YOKlagOf6va+N+
	ybLTm9yJGwWBMTgC6JQEMY9DLSwBp/XnNCerUHNAbA==
X-Google-Smtp-Source: APXvYqyQvYUwaDE/LHd6zbqUqBfKDoNlGm2VDQzp7ApQIQOK1Au2qKqEKdxutbrRvuaMW9sopVqvXXG4ciLpqp7XHr8=
X-Received: by 2002:adf:dcc4:: with SMTP id x4mr1493611wrm.221.1567805250597;
 Fri, 06 Sep 2019 14:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com> <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
 <D2A57C7B-B0FD-424E-9F81-B858FFF21FF0@amacapital.net> <8dc59d585a133e96f9adaf0a148334e7f19058b9.camel@kernel.org>
In-Reply-To: <8dc59d585a133e96f9adaf0a148334e7f19058b9.camel@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 6 Sep 2019 14:27:19 -0700
Message-ID: <CALCETrVR5d2XTpAN8QLRv3cYDfpAdZRNNcD-TtE5H+v7-i7QhQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
To: Jeff Layton <jlayton@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Florian Weimer <fweimer@redhat.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, 
	Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Song Liu <songliubraving@fb.com>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Sep 6, 2019, at 1:51 PM, Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2019-09-06 at 13:06 -0700, Andy Lutomirski wrote:
>
>> I=E2=80=99m not at all convinced that the kernel needs to distinguish al=
l these, but at least upgradability should be its own thing IMO.
>
> Good point. Upgradability is definitely orthogonal, though the idea
> there is to alter the default behavior. If the default is NOEXEC then
> UPGRADE_EXEC would make sense.
>
> In any case, I was mostly thinking about the middle two in your list
> above. After more careful reading of the patches, I now get get that
> Micka=C3=ABl is more interested in the first, and that's really a differe=
nt
> sort of use-case.
>
> Most opens never result in the fd being fed to fexecve or mmapped with
> PROT_EXEC, so having userland explicitly opt-in to allowing that during
> the open sounds like a reasonable thing to do.
>
> But I get that preventing execution via script interpreters of files
> that are not executable might be something nice to have.
>
> Perhaps we need two flags for openat2?
>
> OA2_MAYEXEC : test that permissions allow execution and that the file
> doesn't reside on a noexec mount before allowing the open
>
> OA2_EXECABLE : only allow fexecve or mmapping with PROT_EXEC if the fd
> was opened with this
>
>
>

We could go one step farther and have three masks: check_perms,
fd_perms, and upgrade_perms.  check_perms says =E2=80=9Cfail if I don=E2=80=
=99t have
these perms=E2=80=9D.  fd_perms is the permissions on the returned fd, and
upgrade_perms is the upgrade mask.  (fd_perms  & ~check_perms) !=3D 0 is
an error.  This makes it possible to say "I want to make sure the file
is writable, but I don't actually want to write to it", which could
plausibly be useful.

I would argue that these things should have new, sane bits, e.g.
FILE_READ, FILE_WRITE, and FILE_EXECUTE (or maybe FILE_MAP_EXEC and
FILE_EXECVE).  And maybe there should be at least 16 bits for each
mask reserved.  Windows has a lot more mode bits than Linux, and it's
not entirely nuts.  We do *not* need any direct equivalent of O_RDWR
for openat2().

--Andy
