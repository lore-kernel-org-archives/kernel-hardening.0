MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <8d3e702b-470a-542e-4e0d-6a3c58419f0f@linux.ibm.com>
References: <20180427123547.15727-1-tmricht@linux.ibm.com> <20180427134936.GA31171@kroah.com>
 <CAGXu5j+LK8-g9bg+RNn+-v1LpRC32sTCAUNZr1v0HXquiG9fQw@mail.gmail.com> <8d3e702b-470a-542e-4e0d-6a3c58419f0f@linux.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 2 May 2018 07:29:51 -0700
Message-ID: <CAGXu5j+Fr+=bdWMwkLh2jP2EA4JejTyxqXbr+L99Y7jrDV1X3w@mail.gmail.com>
Subject: Re: [PATCH v2] inode: debugfs_create_dir uses mode permission from parent
Content-Type: text/plain; charset="UTF-8"
To: Thomas-Mich Richter <tmricht@linux.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, brueckner@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 2, 2018 at 12:16 AM, Thomas-Mich Richter
<tmricht@linux.ibm.com> wrote:
> On 04/27/2018 04:58 PM, Kees Cook wrote:
>> On Fri, Apr 27, 2018 at 6:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> I'm going to add Kees and the kernel-hardning list here, as I'd like
>>> their opinions for the patch below.
>>>
>>> Kees, do you have any problems with this patch?  I know you worked on
>>> making debugfs more "secure" from non-root users, this should still keep
>>> the intial mount permissions all fine, right?  Anything I'm not
>>> considering here?
>>
>> This appears correct to me. I'd like to see some stronger rationale
>> for why this is needed, just so I have a "design" to compare the
>> implementation against. :)
>>
>> Normally, the top-level directory permissions should block all the
>> subdirectories too. The only time I think of this being needed is if
>> someone is explicitly bind-mounting a subdirectory to another location
>> (e.g. Chrome OS does this for the i915 subdirectory). In that case,
>> I'd expect them to tweak permissions too. Thomas, what's your
>> use-case?
>>
>> -Kees
>>
>
> There is no 'real use case'. I wrote the patch because of discussions
> regarding file permissions for files located deeply in the
> directory tree, for example
>
>   -r--r--r-- 1 root root 0 Apr 27 14:23 /sys/kernel/debug/kprobes/blacklist
>
> which gives the impression it is world readable.
> This happened to me in recent discussions when I wrote patches to fix some
> of the address randomized output of /sys files which broke the perf tool.
>
> During discussion people often forgot that the root /sys/kernel/debug is rwx for
> root only and blocks non root access to subdirectories and files. They simply
> looked at the file permissions.

Okay, sounds good. "Make permissions less surprising" is a perfectly
good reason to make the change. :)

> I have not thought about the bind-mount case nor did I test this scenario.

I think this case is fine too. Anyone doing this is likely doing some
pretty special things with permissions already.

So, FWIW:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
