Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
	<CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
	<56C7A02F.7070902@redhat.com>
	<CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
	<56CB866A.8070306@redhat.com>
	<CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
Date: Tue, 23 Feb 2016 14:37:58 -0800
Message-ID: <CAGXu5jL8xBHUkZP8_MZk84Zr5efEUGL8z-o0u5_4ybX4CrAmPQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 23, 2016 at 1:25 PM, Kees Cook <keescook@chromium.org> wrote:

> zero poison only:
> DEBUG_PAGEALLOC=n
> PAGE_POISONING=y
> PAGE_POISONING_NO_SANITY=y
> PAGE_POISONING_ZERO=y
> page_poison=on

This combo (in next-20160223) results in an unusable system. :(

[    1.754183] random: init urandom read with 11 bits of entropy available
[    1.768449] hostname (1171) used greatest stack depth: 11808 bytes left
[    1.787954] BUG: Bad page map in process init  pte:3d656c6f736e6f63
pmd:00020067
[    1.789177] addr:00007f9f68200000 vm_flags:00000070 anon_vma:
   (null) mapping:ffff88007c314058 index:141
[    1.790564] file:libdl-2.19.so fault:ext4_filemap_fault
mmap:ext4_file_mmap readpage:ext4_readpage

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
