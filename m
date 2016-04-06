Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
Date: Wed, 6 Apr 2016 10:54:03 -0700
Message-ID: <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=001a113ff0ccbe1940052fd4a57d
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a113ff0ccbe1940052fd4a57d
Content-Type: text/plain; charset=UTF-8

On Wed, Apr 6, 2016 at 8:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'd much rather just not insert the resources in the first place then.

So I'd find a patch like the attached to be perfectly acceptable (in
fact, we should have done this long ago).

That said, for a kernel hardening thing, I think it would be much more
important to just make sure that KASLR is enabled much more. Right now
I think it's disabled in practice if you enable hibernation support,
and I think most distros do that.

So I think that in *practice*, kaslr is much more likely to be
defeated by much more mundane reasons.

             Linus

--001a113ff0ccbe1940052fd4a57d
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imp5lkol0

IGFyY2gveDg2L2tlcm5lbC9zZXR1cC5jIHwgMzcgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDM3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jIGIvYXJjaC94ODYva2VybmVsL3NldHVwLmMKaW5kZXgg
MjM2N2FlMDdlYjc2Li4zMTliMDhhNWI2ZWQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9z
ZXR1cC5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCkBAIC0xNDYsMzEgKzE0Niw2IEBA
IGludCBkZWZhdWx0X2NoZWNrX3BoeXNfYXBpY2lkX3ByZXNlbnQoaW50IHBoeXNfYXBpY2lkKQog
CiBzdHJ1Y3QgYm9vdF9wYXJhbXMgYm9vdF9wYXJhbXM7CiAKLS8qCi0gKiBNYWNoaW5lIHNldHVw
Li4KLSAqLwotc3RhdGljIHN0cnVjdCByZXNvdXJjZSBkYXRhX3Jlc291cmNlID0gewotCS5uYW1l
CT0gIktlcm5lbCBkYXRhIiwKLQkuc3RhcnQJPSAwLAotCS5lbmQJPSAwLAotCS5mbGFncwk9IElP
UkVTT1VSQ0VfQlVTWSB8IElPUkVTT1VSQ0VfU1lTVEVNX1JBTQotfTsKLQotc3RhdGljIHN0cnVj
dCByZXNvdXJjZSBjb2RlX3Jlc291cmNlID0gewotCS5uYW1lCT0gIktlcm5lbCBjb2RlIiwKLQku
c3RhcnQJPSAwLAotCS5lbmQJPSAwLAotCS5mbGFncwk9IElPUkVTT1VSQ0VfQlVTWSB8IElPUkVT
T1VSQ0VfU1lTVEVNX1JBTQotfTsKLQotc3RhdGljIHN0cnVjdCByZXNvdXJjZSBic3NfcmVzb3Vy
Y2UgPSB7Ci0JLm5hbWUJPSAiS2VybmVsIGJzcyIsCi0JLnN0YXJ0CT0gMCwKLQkuZW5kCT0gMCwK
LQkuZmxhZ3MJPSBJT1JFU09VUkNFX0JVU1kgfCBJT1JFU09VUkNFX1NZU1RFTV9SQU0KLX07Ci0K
LQogI2lmZGVmIENPTkZJR19YODZfMzIKIC8qIGNwdSBkYXRhIGFzIGRldGVjdGVkIGJ5IHRoZSBh
c3NlbWJseSBjb2RlIGluIGhlYWQuUyAqLwogc3RydWN0IGNwdWluZm9feDg2IG5ld19jcHVfZGF0
YSA9IHsKQEAgLTk0OSwxMyArOTI0LDYgQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoq
Y21kbGluZV9wKQogCiAJbXB4X21tX2luaXQoJmluaXRfbW0pOwogCi0JY29kZV9yZXNvdXJjZS5z
dGFydCA9IF9fcGFfc3ltYm9sKF90ZXh0KTsKLQljb2RlX3Jlc291cmNlLmVuZCA9IF9fcGFfc3lt
Ym9sKF9ldGV4dCktMTsKLQlkYXRhX3Jlc291cmNlLnN0YXJ0ID0gX19wYV9zeW1ib2woX2V0ZXh0
KTsKLQlkYXRhX3Jlc291cmNlLmVuZCA9IF9fcGFfc3ltYm9sKF9lZGF0YSktMTsKLQlic3NfcmVz
b3VyY2Uuc3RhcnQgPSBfX3BhX3N5bWJvbChfX2Jzc19zdGFydCk7Ci0JYnNzX3Jlc291cmNlLmVu
ZCA9IF9fcGFfc3ltYm9sKF9fYnNzX3N0b3ApLTE7Ci0KICNpZmRlZiBDT05GSUdfQ01ETElORV9C
T09MCiAjaWZkZWYgQ09ORklHX0NNRExJTkVfT1ZFUlJJREUKIAlzdHJsY3B5KGJvb3RfY29tbWFu
ZF9saW5lLCBidWlsdGluX2NtZGxpbmUsIENPTU1BTkRfTElORV9TSVpFKTsKQEAgLTEwMTksMTEg
Kzk4Nyw2IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAogCXg4
Nl9pbml0LnJlc291cmNlcy5wcm9iZV9yb21zKCk7CiAKLQkvKiBhZnRlciBwYXJzZV9lYXJseV9w
YXJhbSwgc28gY291bGQgZGVidWcgaXQgKi8KLQlpbnNlcnRfcmVzb3VyY2UoJmlvbWVtX3Jlc291
cmNlLCAmY29kZV9yZXNvdXJjZSk7Ci0JaW5zZXJ0X3Jlc291cmNlKCZpb21lbV9yZXNvdXJjZSwg
JmRhdGFfcmVzb3VyY2UpOwotCWluc2VydF9yZXNvdXJjZSgmaW9tZW1fcmVzb3VyY2UsICZic3Nf
cmVzb3VyY2UpOwotCiAJZTgyMF9hZGRfa2VybmVsX3JhbmdlKCk7CiAJdHJpbV9iaW9zX3Jhbmdl
KCk7CiAjaWZkZWYgQ09ORklHX1g4Nl8zMgo=
--001a113ff0ccbe1940052fd4a57d--
