MIME-Version: 1.0
In-Reply-To: <CACVxJT8NPnoH+FiXUyyb5Ehjo=8MYhJvwWWWKi5WE7gmhtf_4A@mail.gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
 <1510244046-3256-3-git-send-email-tixxdz@gmail.com> <CACVxJT8NPnoH+FiXUyyb5Ehjo=8MYhJvwWWWKi5WE7gmhtf_4A@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Fri, 10 Nov 2017 11:45:17 +0100
Message-ID: <CAEiveUdnrZijJgTNWaOtH5pLpJ1WaEQib0H-o8AVsU0Yy89_qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v3 2/7] proc: move /proc/{self|thread-self} dentries
 to proc_fs_info
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "J. Bruce Fields" <bfields@fieldses.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 10, 2017 at 11:31 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On 11/9/17, Djalal Harouni <tixxdz@gmail.com> wrote:
>
>>  struct proc_fs_info {
>>       struct pid_namespace *pid_ns;
>> +     struct dentry *proc_self; /* For /proc/self/ */
>> +     struct dentry *proc_thread_self; /* For /proc/thread-self/ */
>
> These are redundant comments.

I can remove them, but actually the area is so difficult and
uncommented that I won't mind extra comments...

Thanks!

-- 
tixxdz
