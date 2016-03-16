Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160314215217.7fa20e0c85bfda75dc11b70c@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000427.c82f18670568e1e656fc9532@gmail.com>
	<CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
	<20160314215217.7fa20e0c85bfda75dc11b70c@gmail.com>
Date: Wed, 16 Mar 2016 16:41:36 +0900
Message-ID: <CAK7LNARDyW3Si45rUaUpHhhmqO4hmN-mTdVK4zxqg23cuByAtQ@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,

2016-03-15 5:52 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> On Fri, 11 Mar 2016 15:25:19 +0900
> Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
>
>> Maybe scripts/gcc-plugins/ is better than tools/gcc ?
>>
>> In the directory "scripts/", we have several tools used during
>> building the kernel image.
>> We have some optional programs in the directory "tools/", which are not used
>> for building the kernel image itself.
>>
>> Please correct me if I am wrong.
>
> I think scripts isn't the right place because there are tools there which don't get used
> during the building of vmlinux (e.g., coccinelle, checkpatch).

No, this is not what I meant.

What I want to say is:
All the host tools used for building vmlinux should be located in the
directory "scripts/",
but the directory may also other host tools that are not used for
building vmlinux (such as checkpatch).


> The scripts name also doesn't describe gcc plugins well.

With my suggestion "scripts/gcc-plugins/",
the sub-directory name describes it very well.


> Plugins take part in the image building process
> in a different way than these tools and scripts do.
> Since there doesn't seen to be a good place for compiler plugins, maybe we should create a new toplevel directory
> called "build". Compiler plugins and other existing build tools could live there. What do you think?

In my understanding, they are plug-in'ed into the cross-compiler that
compiles vmlinux.

If so, GCC plugins should be happy in "scripts/"
because Kbuild descends into "scripts/" before building any objects for vmlinux.


-- 
Best Regards
Masahiro Yamada
