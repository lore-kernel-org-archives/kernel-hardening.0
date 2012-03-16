Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1331921799.19406.20.camel@edumazet-glaptop>
References: <1331781125-15658-1-git-send-email-wad@chromium.org>
	<1331781125-15658-3-git-send-email-wad@chromium.org>
	<1331921799.19406.20.camel@edumazet-glaptop>
Date: Fri, 16 Mar 2012 14:23:15 -0500
Message-ID: <CABqD9haBppbqAvcEYP_nstB7aZc-PbVvHwj+P69AQ5+Z87FofA@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v15 02/13] net/compat.c,linux/filter.h: share compat_sock_fprog
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2012 at 1:16 PM, Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
> On Wed, 2012-03-14 at 22:11 -0500, Will Drewry wrote:
>> Any other users of bpf_*_filter that take a struct sock_fprog from
>> userspace will need to be able to also accept a compat_sock_fprog
>> if the arch supports compat calls. =A0This change let's the existing
>> compat_sock_fprog be shared.
>>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>>
>> v14: rebase/nochanges
>> v13: rebase on to 88ebdda6159ffc15699f204c33feb3e431bf9bdc
>> v12: rebase on to linux-next
>> v11: introduction
>> ---
>> =A0include/linux/filter.h | =A0 11 +++++++++++
>> =A0net/compat.c =A0 =A0 =A0 =A0 =A0 | =A0 =A08 --------
>> =A02 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index aaa2e80..f2e5315 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -10,6 +10,7 @@
>>
>> =A0#ifdef __KERNEL__
>> =A0#include <linux/atomic.h>
>> +#include <linux/compat.h>
>> =A0#endif
>>
>> =A0/*
>> @@ -132,6 +133,16 @@ struct sock_fprog { =A0 =A0 =A0/* Required for SO_A=
TTACH_FILTER. */
>>
>> =A0#ifdef __KERNEL__
>>
>> +#ifdef CONFIG_COMPAT
>> +/*
>> + * A struct sock_filter is architecture independent.
>> + */
>> +struct compat_sock_fprog {
>> + =A0 =A0 u16 =A0 =A0 =A0 =A0 =A0 =A0 len;
>> + =A0 =A0 compat_uptr_t =A0 filter; =A0 =A0 =A0 =A0 /* struct sock_filte=
r * */
>> +};
>> +#endif
>> +
>> =A0struct sk_buff;
>> =A0struct sock;
>>
>> diff --git a/net/compat.c b/net/compat.c
>> index 6def90e..c5c61c8 100644
>> --- a/net/compat.c
>> +++ b/net/compat.c
>> @@ -326,14 +326,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, str=
uct scm_cookie *scm)
>> =A0 =A0 =A0 __scm_destroy(scm);
>> =A0}
>>
>> -/*
>> - * A struct sock_filter is architecture independent.
>> - */
>> -struct compat_sock_fprog {
>> - =A0 =A0 u16 =A0 =A0 =A0 =A0 =A0 =A0 len;
>> - =A0 =A0 compat_uptr_t =A0 filter; =A0 =A0 =A0 =A0 /* struct sock_filte=
r * */
>> -};
>> -
>> =A0static int do_set_attach_filter(struct socket *sock, int level, int o=
ptname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char __user =
*optval, unsigned int optlen)
>> =A0{
>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Added your Acked-by's to the tree at

  https://github.com/redpig/linux/tree/seccomp

Thanks!
will
