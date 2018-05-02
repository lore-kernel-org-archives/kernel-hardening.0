Subject: Re: [PATCH v2] inode: debugfs_create_dir uses mode permission from
 parent
References: <20180427123547.15727-1-tmricht@linux.ibm.com>
 <20180427134936.GA31171@kroah.com>
 <CAGXu5j+LK8-g9bg+RNn+-v1LpRC32sTCAUNZr1v0HXquiG9fQw@mail.gmail.com>
From: Thomas-Mich Richter <tmricht@linux.ibm.com>
Date: Wed, 2 May 2018 09:16:29 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+LK8-g9bg+RNn+-v1LpRC32sTCAUNZr1v0HXquiG9fQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <8d3e702b-470a-542e-4e0d-6a3c58419f0f@linux.ibm.com>
To: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, brueckner@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/27/2018 04:58 PM, Kees Cook wrote:
> On Fri, Apr 27, 2018 at 6:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> I'm going to add Kees and the kernel-hardning list here, as I'd like
>> their opinions for the patch below.
>>
>> Kees, do you have any problems with this patch?  I know you worked on
>> making debugfs more "secure" from non-root users, this should still keep
>> the intial mount permissions all fine, right?  Anything I'm not
>> considering here?
> 
> This appears correct to me. I'd like to see some stronger rationale
> for why this is needed, just so I have a "design" to compare the
> implementation against. :)
> 
> Normally, the top-level directory permissions should block all the
> subdirectories too. The only time I think of this being needed is if
> someone is explicitly bind-mounting a subdirectory to another location
> (e.g. Chrome OS does this for the i915 subdirectory). In that case,
> I'd expect them to tweak permissions too. Thomas, what's your
> use-case?
> 
> -Kees
> 

There is no 'real use case'. I wrote the patch because of discussions
regarding file permissions for files located deeply in the
directory tree, for example

  -r--r--r-- 1 root root 0 Apr 27 14:23 /sys/kernel/debug/kprobes/blacklist

which gives the impression it is world readable.
This happened to me in recent discussions when I wrote patches to fix some
of the address randomized output of /sys files which broke the perf tool.

During discussion people often forgot that the root /sys/kernel/debug is rwx for
root only and blocks non root access to subdirectories and files. They simply
looked at the file permissions.

I have not thougth about the bind-mount case nor did I test this scenario.

-- 
Thomas Richter, Dept 3303, IBM s390 Linux Development, Boeblingen, Germany
--
Vorsitzende des Aufsichtsrats: Martina Koederitz 
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
