import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Chính sách'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.w),
        width: 414.w,
        child: ListView(
          children: [
            Text(
              'Chính sách Bảo mật này mô tả các chính sách và thủ tục của Chúng tôi về việc thu thập, sử dụng và tiết lộ thông tin của Bạn khi Bạn sử dụng Dịch vụ và cho Bạn biết về quyền riêng tư của Bạn và cách luật pháp bảo vệ Bạn.',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Chúng tôi sử dụng dữ liệu Cá nhân của Bạn để cung cấp và cải thiện Dịch vụ. Bằng việc sử dụng Dịch vụ, Bạn đồng ý với việc thu thập và sử dụng thông tin theo Chính sách Bảo mật này. Chính sách Bảo mật này đã được tạo với sự trợ giúp của Trình tạo Chính sách Bảo mật.',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Thu thập và sử dụng dữ liệu cá nhân của bạn',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Trong khi sử dụng Dịch vụ của Chúng tôi, Chúng tôi có thể yêu cầu Bạn cung cấp cho Chúng tôi một số thông tin nhận dạng cá nhân nhất định có thể được sử dụng để liên hệ hoặc nhận dạng Bạn. Thông tin nhận dạng cá nhân có thể bao gồm, nhưng không giới hạn ở: Địa chỉ email, tên và họ, số điện thoại, địa chỉ',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Thông tin được thu thập khi sử dụng ứng dụng',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Trong khi sử dụng Ứng dụng của Chúng tôi, để cung cấp các tính năng của Ứng dụng của Chúng tôi, Chúng tôi có thể thu thập, với sự cho phép trước của Bạn:\n-Thông tin liên quan đến vị trí của bạn\n-Ảnh và thông tin khác từ máy ảnh và thư viện ảnh trên Thiết bị của bạn',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Bảo mật dữ liệu cá nhân của bạn',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Việc bảo mật Dữ liệu Cá nhân của Bạn là quan trọng đối với Chúng tôi, nhưng hãy nhớ rằng không có phương thức truyền tải nào qua Internet hoặc phương pháp lưu trữ điện tử là an toàn 100%. Trong khi Chúng tôi cố gắng sử dụng các phương tiện được chấp nhận về mặt thương mại để bảo vệ Dữ liệu Cá nhân của Bạn, Chúng tôi không thể đảm bảo tính bảo mật tuyệt đối của Dữ liệu đó.',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Liên hệ chúng tôi',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Nếu bạn có bất kỳ câu hỏi nào về Chính sách Bảo mật này, Bạn có thể liên hệ với chúng tôi:\nQua email: 17130044@st.hcmuaf.edu.vn',
              style: TextStyle(fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }
}
