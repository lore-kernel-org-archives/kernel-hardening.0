MIME-Version: 1.0
In-Reply-To: <20170504142435.10175-1-danielmicay@gmail.com>
References: <20170504142435.10175-1-danielmicay@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 4 May 2017 10:51:43 -0400
Message-ID: <CA+DvKQKDdjrVnH8TCnS4Z=yjsnJqj7HJw7XvyL4atPZDE7jesQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] add the option of fortified string.h functions
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

There are temporary workarounds for the overflows this found in
https://github.com/thestinger/linux-hardened/commits/4.11, but not
real fixes yet. There are some mostly harmless misuses of memcpy
instead of strncpy and memcmp instead of strncmp where the source is a
string constant. The arm64 vdso code uses memcmp with the address of
'char vdso_start' so perhaps that can become 'char
vdso_start[PAGE_SIZE]' instead. One of the issues looks a bit more
concerning.

I haven't found any issues at runtime but that doesn't mean much since
none of the compile-time issues were in code that's used on my
desktop. This has been used on a 3.18 LTS arm64 kernel targeting the
Pixel / Pixel XL on CopperheadOS for a while and found a real runtime
stack buffer write overflow there in an out-of-tree driver. I'm
somewhat surprised by the fact that there are real buffer overflows
lying around that are this easily found without any fuzzing, etc.
rather than this feature only providing a fair bit of runtime coverage
to mitigate bugs that require edge cases.
