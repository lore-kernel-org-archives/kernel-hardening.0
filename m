MIME-Version: 1.0
In-Reply-To: <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net> <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
 <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 11 Jul 2017 18:58:13 +0200
Message-ID: <CAJHCu1K1Hg5M2HhJxN_aj2P_S8Pez9+8KL=wHKBgAN0jN1+mLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Matt Brown <matt@nmatt.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-07-11 1:40 GMT+02:00 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>:
>
> On 10/07/2017 09:59, Salvatore Mesoraca wrote:
>> 2017-07-09 21:35 GMT+02:00 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>:
>>> Hi,
>>>
>>> I think it make sense to merge the W^X features with the TPE/shebang LS=
M
>>> [1].
>>>
>>> Regards,
>>>  Micka=C3=ABl
>>>
>>> [1]
>>> https://lkml.kernel.org/r/d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.=
net
>>
>> Hi,
>> Can you elaborate why it would be an advantage to have those features me=
rged?
>> They seem quite unrelated.
>> Also, they work in rather different ways in respect to how they are conf=
igured.
>> I'm not sure what would be a reasonable way to merge them.
>> Thank you for your comment,
>>
>> Salvatore
>>
>
> The aim of the Trusted Path Execution is to constraint calls to execve
> (e.g. forbid an user to execute his own binaries, i.e. apply a W^X
> security policy). This should handle binaries and could handle scripts
> too [1]. However, there is always a way for a process to mmap/mprotect
> arbitrary data and make it executable, be it intentional or not. PaX and
> the W^X part of your LSM can handle this, or make exceptions by marking
> a file with dedicated xattr values. This kind of exception fit well with
> TPE to get a more hardened executable security policy (e.g. forbid an
> user to execute his own binaries or to mmap arbitrary executable code).
> Moreover, TPE could handle some part of its configuration from some
> xattr values (e.g. allow scripts/interpreters, a whitelist of
> environment variables, additional memory restrictions=E2=80=A6) as you do=
 with
> SARA thanks to your tools.

I understand your point. They complement each other in some sense.
On the other hand, I'm still worried about the suitability of merging,
under the same LSM, two features that are managed in two
completely different ways.
IMHO, if they have to be merged, they should be "integrated".
As I see it, there are only 3 possible solutions to this problem:
1 - SARA gives up its configuration mechanics and starts using xattrs
2 - TPE/shebang gives up xattrs and starts using SARA-style configurations
3 - SARA adds xattrs support to its quiver *and* TPE/shebang adds SARA-styl=
e
     configuration support.

The solution number 1 is the one I'm less inclined to, as you can imagine.
I'm in favor of solutions 2 and 3, but of course we need to know Mimi Zohar=
 and
Matt Brown opinion on this matter.
If we can find a consensus on the best way to merge them, I'm not against
the merge.
Anyway, these LSMs are stackable and they can be used together even if they
don't get merged. So I think that merging them is not a "must".

Salvatore
