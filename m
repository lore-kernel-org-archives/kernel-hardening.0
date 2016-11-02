Reply-To: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: Dave Tian <dave.jing.tian@gmail.com>
In-Reply-To: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz>
Date: Wed, 2 Nov 2016 11:00:20 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A543634-BA18-48ED-A32C-3F44F3BFD11F@gmail.com>
References: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz>
Subject: Re: [kernel-hardening] Legitimate use of /proc/PID/mem,maps and smaps
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> On Nov 1, 2016, at 11:42 PM, Marian Marinov <mm-l@yuhu.biz> wrote:
>=20
> Hi guys,
> after dirtyCoW me and colleges of mine started discussing different =
vectors of exploiting applications and we noticed that a lot of the =
exploits we were discussing relied on /proc/PID/mem or mpas or smaps to =
be readable by the same user.
>=20
> We started thinking of legitimate use of these files (lsof, gdb with =
plugins and valgrind). Are there any other legitimate users of these =
files, maybe X?
>=20
> I'm considering writing a patch, which will make sure that nobody, =
even the owner of the process, can't open these files and only root or =
users with CAP_DAC_OVERRIDE and/or CAP_SYS_ADMIN can see these files.
> For everyone that is not root and lacks DAC_OVERRIDE and SYS_ADMIN the =
files should not exists.
>=20
> What do you think about this?
>=20
> Best regards,
> Marian

I do not see a problem of a process looking into its own address space. =
The root cause of dirtycow is not the permission of accessing =
/proc/self/mem, which only provides a trigger, same as ptrace(), but the =
race condition between the cowed page and unmmap, although I do agree if =
there is a better/reasonable way to limit the attack surface, just like =
limiting perf, without breaking user-space tools.

-daveti
