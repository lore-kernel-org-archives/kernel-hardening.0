Reply-To: kernel-hardening@lists.openwall.com
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458784008-16277-5-git-send-email-mic@digikod.net>
 <CAGXu5jK-phbh+fADwAyK__ac_Zxezeo1mpbDPtfQNqK8=7X0wQ@mail.gmail.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56FAA18C.4040406@osg.samsung.com>
Date: Tue, 29 Mar 2016 09:38:52 -0600
MIME-Version: 1.0
In-Reply-To: <CAGXu5jK-phbh+fADwAyK__ac_Zxezeo1mpbDPtfQNqK8=7X0wQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC v1 04/17] selftest/seccomp: Fix the seccomp(2) signature
To: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/23/2016 10:36 PM, Kees Cook wrote:
> On Wed, Mar 23, 2016 at 6:46 PM, Mickaël Salaün <mic@digikod.net> wrote:
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Will Drewry <wad@chromium.org>
> 
> Another good catch. Shuah, can you take this one too?
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> -Kees

Hi Michael,

Could you please send me the patch. I can't find it in my Inbox. I can get
this into rc-2 with Kees Cook's ack.

thanks,
-- Shuah

> 
>> ---
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> index 9c1460f277c2..150829dd7998 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -1502,10 +1502,10 @@ TEST_F(TRACE_syscall, syscall_dropped)
>>  #endif
>>
>>  #ifndef seccomp
>> -int seccomp(unsigned int op, unsigned int flags, struct sock_fprog *filter)
>> +int seccomp(unsigned int op, unsigned int flags, void *args)
>>  {
>>         errno = 0;
>> -       return syscall(__NR_seccomp, op, flags, filter);
>> +       return syscall(__NR_seccomp, op, flags, args);
>>  }
>>  #endif
>>
>> --
>> 2.8.0.rc3
>>
> 
> 
> 
