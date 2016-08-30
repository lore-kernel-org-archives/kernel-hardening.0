Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <57C5E3C8.1080103@digikod.net>
References: <1472121165-29071-1-git-send-email-mic@digikod.net>
 <CALCETrWw6fTTugSFcBhW=fv09GrSXQ+vZxuG0ewb+cod8nq4MQ@mail.gmail.com> <57C5E3C8.1080103@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Aug 2016 12:55:07 -0700
Message-ID: <CALCETrX3XrG=VsUdiZJbd_J594D9YKbpOH9CoT6cFocWZpr8dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC v2 00/10] Landlock LSM: Unprivileged sandboxing
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Will Drewry <wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 30, 2016 at 12:51 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net=
> wrote:
>
> On 30/08/2016 18:06, Andy Lutomirski wrote:
>> On Thu, Aug 25, 2016 at 3:32 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.n=
et> wrote:
>>> Hi,
>>>
>>> This series is a proof of concept to fill some missing part of seccomp =
as the
>>> ability to check syscall argument pointers or creating more dynamic sec=
urity
>>> policies. The goal of this new stackable Linux Security Module (LSM) ca=
lled
>>> Landlock is to allow any process, including unprivileged ones, to creat=
e
>>> powerful security sandboxes comparable to the Seatbelt/XNU Sandbox or t=
he
>>> OpenBSD Pledge. This kind of sandbox help to mitigate the security impa=
ct of
>>> bugs or unexpected/malicious behaviors in userland applications.
>>
>> Micka=C3=ABl, will you be at KS and/or LPC?
>>
>
> I won't be at KS/LPC but I will give a talk at Kernel Recipes (Paris)
> for which registration will start Thursday (and will not last long). :)

There's a teeny tiny chance I'll be there.  I've done way too much
traveling lately.
