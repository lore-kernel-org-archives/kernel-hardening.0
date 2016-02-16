Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160215072935.GB2816@x1.redhat.com>
References: <1436300428-21163-1-git-send-email-yinghai@kernel.org>
	<CAGXu5jKtBDziww4p_cJi-u=EHYdz9mqy87ca5xrCHY_MGN3+yw@mail.gmail.com>
	<CAGXu5jKLyYEgoz5yS+y5Gu-2xS3H9wWKu2YZWWt0Nof1ZTm3QQ@mail.gmail.com>
	<1232989951.18951930.1454759421059.JavaMail.zimbra@redhat.com>
	<CAGXu5jJy+N9=xF7=WmGVXxpM3f7vbb7nhN=RYQXt-NiUhqz=7w@mail.gmail.com>
	<20160215072935.GB2816@x1.redhat.com>
Date: Tue, 16 Feb 2016 15:50:40 -0800
Message-ID: <CAGXu5jJ_KTp08gTms34GGa23fuYE5Mty=9e28inu8w3BWSjMjA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 00/42] x86: updated patches for kaslr and setup_data etc
 for v4.3
To: Baoquan He <bhe@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 14, 2016 at 11:29 PM, Baoquan He <bhe@redhat.com> wrote:
> On 02/08/16 at 08:31pm, Kees Cook wrote:
>> On Sat, Feb 6, 2016 at 3:50 AM, Baoquan He <bhe@redhat.com> wrote:
>> > Hi,
>> >
>> > Recently people using big box servers are also very interested in kaslr and want
>> > to have it to enhance security. So allowing kaslr be able to randomize above 4G
>> > makes much sense for different kinds of system. I would like to repost patches
>> > realted to kaslr in this patchset, and leave the rest to Yinghai. Or I can try
>> > to understand and adjust the rest with yh and reviewers' help, then post. But
>> > firstly I will focus on kaslr and try to make it merge into Linus's tree.
>> >
>> > Since this patchset includes too many issues and people usually like reviewing
>> > post which takes care of one main issue in one thread, I will start from below
>> > thread. It mainly includes kaslr above 4G support and bug fixes and several clean
>> > up patch.
>> >
>> > x86, boot: kaslr cleanup and 64bit kaslr support
>> > https://lwn.net/Articles/637115/
>> >
>> > The following patch lists is taken from yh's cover letter of above patch thread.
>> >
>> > **************************
>> > My plan is split them into
>> > 1) kaslr above 4G support
>> >   x86, boot: Split kernel_ident_mapping_init to another file
>> >   x86, 64bit: Set ident_mapping for kaslr
>> >   x86, boot: Add checking for memcpy
>> >   x86, boot: Move z_extract_offset calculation to header.S
>> >   x86, boot: Simplify run_size calculation
>> >   x86, kaslr: Kill not used run_size related code.
>> >   x86, kaslr: Use output_run_size
>> >   x86, kaslr: Fix a bug that relocation can not be handled when kernel is loaded above 2G
>> >   x86, kaslr: Introduce struct slot_area to manage randomization slot info
>> >   x86, kaslr: Add two functions which will be used later
>> >   x86, kaslr: Introduce fetch_random_virt_offset to randomize the kernel text mapping address
>> >   x86, kaslr: Randomize physical and virtual address of kernel separately
>> >   x86, kaslr: Add support of kernel physical address randomization above 4G
>> >   x86, kaslr: Remove useless codes
>> > 2) allow kaslr to choose slots below loaded address
>> >   x86, kaslr: Consolidate mem_avoid array filling
>> >   x86, kaslr: Allow random address could be below loaded address
>> > 3) Make data from decompress_kernel stage live longer (bug fix)
>> >   x86, boot: Make data from decompress_kernel stage live longer
>> > 4) Get correct max_addr for relocs pointer (improvement)
>> >   x86, kaslr: Get correct max_addr for relocs pointer
>> >
>> > The 2) could be added into 1) post. I take it out because the mem_avoid issue is very
>> > complicated, can be discussed in a separate thread. And 1) post only focus the kaslr
>> > above 4G support.
>> >
>> > That's all I plan to do. Suggestion or comments are welcome.
>>
>> That sounds great, thanks! Please check the rest of the thread where I
>> asked a number of questions that remain unanswered. If we can get some
>> clarification on those points, I think it would help move this along
>> more quickly.
>
> Hi Kees,
>
> Thanks for your suggestion. I am trying to understand all patches and
> make some adjustment, meanwhile adjust patch log with my understanding.
> And your questions help me understand it deeper. I will post after
> updating. Hope you, Yinghai and other experts can help review and give
> precious comments and suggestions.

Sounds great! I look forward to them. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
