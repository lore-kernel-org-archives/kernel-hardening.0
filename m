MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170528075313.GB22193@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-2-git-send-email-keescook@chromium.org> <20170528075313.GB22193@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 28 May 2017 09:55:37 -0700
Message-ID: <CAGXu5jL3w=y_EXA9cdx-6VUhKDaGpSFSxJsY+iP_ocf54A4MdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 01/20] NFS: Avoid cross-structure casting
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 28, 2017 at 12:53 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 26, 2017 at 01:17:05PM -0700, Kees Cook wrote:
>> When the call to nfs_devname() fails, the error path attempts to retain
>> the error via the mnt variable, but this requires a cast across very
>> different types (char * to struct vfsmount *), which the upcoming
>> structure layout randomization plugin flags as being potentially
>> dangerous in the face of randomization. This is a false positive, but
>> what this code actually wants to do is retain the error value, so this
>> patch explicitly sets it, instead of using what seems to be an
>> unexpected cast.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> And I think we should get this (and the other cast patches) in ASAP,
> independent of the fat of the randstruct plugin.

Should I send a pull request to Linus for these for v4.12?

-Kees

-- 
Kees Cook
Pixel Security
