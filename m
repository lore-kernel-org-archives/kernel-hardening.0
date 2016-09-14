Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160914072415.26021-12-mic@digikod.net>
References: <20160914072415.26021-1-mic@digikod.net> <20160914072415.26021-12-mic@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Sep 2016 11:43:54 -0700
Message-ID: <CALCETrXm18nNDY-a+toBEcjKKh+zOCVG0=t3ufkpROOHdqfqJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC v3 11/22] seccomp,landlock: Handle Landlock hooks per
 process hierarchy
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 14, 2016 at 12:24 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net=
> wrote:
> A Landlock program will be triggered according to its subtype/origin
> bitfield. The LANDLOCK_FLAG_ORIGIN_SECCOMP value will trigger the
> Landlock program when a seccomp filter will return RET_LANDLOCK.
> Moreover, it is possible to return a 16-bit cookie which will be
> readable by the Landlock programs in its context.

Are you envisioning that the filters will return RET_LANDLOCK most of
the time or rarely?  If it's most of the time, then maybe this could
be simplified a bit by unconditionally calling the landlock filter and
letting the landlock filter access a struct seccomp_data if needed.


>
> Only seccomp filters loaded from the same thread and before a Landlock
> program can trigger it through LANDLOCK_FLAG_ORIGIN_SECCOMP. Multiple
> Landlock programs can be triggered by one or more seccomp filters. This
> way, each RET_LANDLOCK (with specific cookie) will trigger all the
> allowed Landlock programs once.

This interface seems somewhat awkward.  Should we not have a way to
atomicaly install a whole pile of landlock filters and associated
seccomp filter all at once?

--Andy
