Return-Path: <SRS0=DPRV=XB=lists.openwall.com=kernel-hardening-return-16859-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E83C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:50:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2A597214E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A597214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16859-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15967 invoked by uid 550); 6 Sep 2019 18:50:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15947 invoked from network); 6 Sep 2019 18:50:18 -0000
From: Steve Grubb <sgrubb@redhat.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>, Steve Dower <steve.dower@python.org>, Thibaut Sautereau <thibaut.
 sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 06 Sep 2019 14:50:02 -0400
Message-ID: <2989749.1YmIBkDdQn@x2>
Organization: Red Hat
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
References: <20190906152455.22757-1-mic@digikod.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 06 Sep 2019 18:50:06 +0000 (UTC)

On Friday, September 6, 2019 11:24:50 AM EDT Micka=EBl Sala=FCn wrote:
> The goal of this patch series is to control script interpretation.  A
> new O_MAYEXEC flag used by sys_open() is added to enable userspace
> script interpreter to delegate to the kernel (and thus the system
> security policy) the permission to interpret/execute scripts or other
> files containing what can be seen as commands.

The problem is that this is only a gentleman's handshake. If I don't tell t=
he
kernel that what I'm opening is tantamount to executing it, then the securi=
ty
feature is never invoked. It is simple to strip the flags off of any system
call without needing privileges. For example:

#define _GNU_SOURCE
#include <link.h>
#include <fcntl.h>
#include <string.h>

unsigned int
la_version(unsigned int version)
{
    return version;
}

unsigned int
la_objopen(struct link_map *map, Lmid_t lmid, uintptr_t *cookie)
{
    return LA_FLG_BINDTO | LA_FLG_BINDFROM;
}

typedef int (*openat_t) (int dirfd, const char *pathname, int flags, mode_t=
 mode);
static openat_t real_openat =3D 0L;
int my_openat(int dirfd, const char *pathname, int flags, mode_t mode)
{
        flags &=3D ~O_CLOEXEC;
        return real_openat(dirfd, pathname, flags, mode);
}

uintptr_t
la_symbind64(Elf64_Sym *sym, unsigned int ndx, uintptr_t *refcook,
        uintptr_t *defcook, unsigned int *flags, const char *symname)
{
    if (real_openat =3D=3D 0L && strcmp(symname, "openat") =3D=3D 0) {
        real_openat =3D (openat_t) sym->st_value;
        return (uintptr_t) my_openat;
    }
    return sym->st_value;
}

gcc -c -g -Wno-unused-parameter -W -Wall -Wundef -O2 -Wp,-D_GLIBCXX_ASSERTI=
ONS -fexceptions -fPIC  test.c
gcc -o strip-flags.so.0 -shared -Wl,-soname,strip-flags.so.0 -ldl test.o

Now, let's make a test program:

#include <stdio.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
        int dir_fd, fd;
        DIR *d =3D opendir("/etc");
        dir_fd =3D dirfd(d);
        fd =3D openat(dir_fd, "passwd", O_RDONLY|O_CLOEXEC);
        close (fd);
        closedir(d);
        return 0;
}

gcc -g -W -Wall -Wundef test.c -o test

OK, let's see what happens.
$ strace ./test 2>&1 | grep passwd
openat(3, "passwd", O_RDONLY|O_CLOEXEC) =3D 4

Now with LD_AUDIT
$ LD_AUDIT=3D/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test 2>&=
1 | grep passwd
openat(3, "passwd", O_RDONLY)           =3D 4

No O_CLOEXEC flag.

=2DSteve


